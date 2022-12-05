defmodule Mix.Tasks.Compile.Gleam do
  use Mix.Task

  @shortdoc "Compiles Gleam source files"
  @recursive true

  @shell Mix.shell()

  @moduledoc """
  Compiles a single Gleam package.

  This task wraps `gleam compile-package` and ensures that any Gleam code, in the main
  project and any dependencies, is compiled into Erlang, a task that should happen
  prior to Mix's compilation.

  ## Examples:

      # Compile Gleam to Erlang in the Mix project.
      mix compile.gleam

      # Compile Gleam to Erlang in a dependency.
      mix compile.gleam gleam_stdlib

      # Compile several dependencies.
      mix compile.gleam gleam_http gleam_otp

      # Force Gleam compilation.
      mix compile.gleam gleam_plug --force

      # Prevent Gleam compilation.
      mix deps.compile --no-gleam

  Note that Gleam compilation can also be explicitly disabled for individual dependencies
  via `mix.exs` using, e.g.:

      defp deps() do
        [
          ...
          {:package, "~> 0.1", gleam: false},
        ]
      end

  Gleam compilation will not be attempted in cases where it is thought to be unnecessary,
  unless the `--force` or `--force-gleam` flag or config option is passed; though even then,
  Gleam compilation will not occur where no `.gleam` files are located.

  Include this task in your project's `mix.exs` with, e.g.:

      def project do
        [
          compilers: [:gleam] ++ Mix.compilers(),
        ]
      end

  """

  @switches [
    force: :boolean,
    force_gleam: :boolean,
    gleam: :boolean
  ]

  @impl true
  def run(args) do
    MixGleam.IO.debug_info("Compile Start")

    Mix.Project.get!()

    case OptionParser.parse(args, switches: @switches) do
      {options, [], _} ->
        config = Mix.Project.config()
        compile(Keyword.merge(config, options), :mix)

      {options, tail, _} ->
        deps = Mix.Dep.load_and_cache()

        tail
        |> Mix.Dep.filter_by_name(deps, options)
        |> Enum.each(fn %Mix.Dep{manager: manager, opts: opts} = dep ->
          Mix.Dep.in_dependency(dep, fn _module ->
            compile(Keyword.merge(opts, options), manager)
          end)
        end)
    end

    MixGleam.IO.debug_info("Compile End")
  end

  @doc false
  def compile(options \\ [], manager \\ nil) do
    cmd? = fn -> not is_nil(options[:compile]) end

    force? = fn ->
      [:force, :force_gleam]
      |> Stream.map(&Keyword.get(options, &1, false))
      |> Enum.any?()
    end

    gleam? = fn -> Keyword.get(options, :gleam, true) end
    has_own_gleam_manager? = fn -> manager not in [nil, :mix] end

    proceed? = fn -> not has_own_gleam_manager?.() and not cmd?.() end

    if gleam?.() and (force?.() or proceed?.()) do
      app =
        try do
          Keyword.get_lazy(options, :app, fn -> elem(options[:lock], 1) end)
        rescue
          _ -> raise MixGleam.Error, message: "Unable to find app name"
        end

      compile_package(app)
    end

    :ok
  end

  @doc false
  def compile_package(app, tests? \\ false) do
    search_paths =
      unless tests? do
        ["*{src,lib}"]
      else
        ["*test"]
      end

    files =
      MixGleam.find_files(search_paths)
      |> Enum.count()

    if 0 < files do
      lib = Path.join(Mix.Project.build_path(), "lib")
      build = Path.join(lib, "#{app}")
      out = "build/dev/erlang/#{app}"

      File.mkdir_p!(build)

      # A minimal `gleam.toml` config with a project name is required by
      # `gleam compile-package`.
      #
      # We create one here if necessary, in Mix's build directory rather than
      # the project's base directory (to avoid invoking Gleam's language
      # server).
      #
      package =
        unless File.regular?("gleam.toml") do
          config = Path.join(build, "gleam.toml")

          unless File.regular?(config) do
            File.write!(config, ~s(name = "#{app}"))
          end

          ["src", "test"]
          |> Enum.each(fn dir ->
            src = Path.absname(dir)
            dest = Path.join(build, dir)
            File.rm_rf!(dest)

            if File.ln_s(src, dest) != :ok do
              File.cp_r!(src, dest)
            end
          end)

          build
        else
          "."
        end

      File.rm_rf!(out)

      cmd =
        "gleam compile-package --target erlang --no-beam --package #{package} --out #{out} --lib #{lib}"

      @shell.info(
        ~s(Compiling #{files} #{if tests?, do: "test "}file#{if 1 != files, do: "s"} (.gleam\))
      )

      MixGleam.IO.debug_info("Compiler Command", cmd)
      compiled? = @shell.cmd(cmd) === 0

      if compiled? do
        app_path = Mix.Project.app_path()

        out
        |> File.ls!()
        |> Enum.each(fn item ->
          src = Path.join(out, item)
          dest = Path.join(app_path, item)

          case File.lstat(src) do
            # Windows disallows copying over existing symlinks.
            # Mix creates some symlinks on its own, e.g. priv.
            #
            {:ok, %File.Stat{type: :symlink}} -> []
            _else -> File.cp_r!(src, dest)
          end
        end)

        # TODO reuse when `gleam` conditionally compiles tests
        # if not tests? and Mix.env() in [:dev, :test] do
        #   compile_package(app, true)
        # end
      else
        raise MixGleam.Error, message: "Compilation failed"
      end
    end

    :ok
  end
end
