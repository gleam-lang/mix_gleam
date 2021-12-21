defmodule Mix.Tasks.Gleam.Compile do
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
      mix gleam.compile

      # Compile Gleam to Erlang in a dependency.
      mix gleam.compile gleam_stdlib

      # Compile several dependencies.
      mix gleam.compile gleam_http gleam_otp

      # Force Gleam compilation.
      mix gleam.compile gleam_plug --force 

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
          # [...]
          aliases: MixGleam.add_aliases(),

          # or
          aliases: [
            "my.task": ["help"]
          ]
          |> MixGleam.add_aliases,

          # or
          aliases: ["compile.all": ["gleam.compile", "compile.all"]],
        ]
      end

  """

  @switches [
    force: :boolean,
    force_gleam: :boolean,
    gleam: :boolean,
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
      |> Enum.any?
    end
    gleam? = fn -> Keyword.get(options, :gleam, true) end
    has_own_gleam_manager? = fn -> manager not in [nil, :mix] end

    proceed? = fn -> not has_own_gleam_manager?.() and not cmd?.() end

    if gleam?.() do
      if force?.() or proceed?.() do
        app =
          try do
            Keyword.get_lazy(options, :app, fn -> elem(options[:lock], 1) end)
          rescue
            _ -> raise MixGleam.Error, message: "Unable to find app name"
          end
        compile_package(app)
      end
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
      |> Enum.count

    if 0 < files do
      out = "build/dev/erlang/#{app}/build"

      # TODO remove when `gleam` handles this
      File.mkdir_p(out)
      Path.join(search_paths ++ ["**/*.{e,h}rl"])
      |> Path.wildcard
      |> Enum.each(&File.cp(&1, Path.join(out, Path.basename(&1))))

      cmd = "gleam compile-package --target erlang --name #{app} --src #{MixGleam.find_paths([""], search_paths) |> hd} --out #{out} #{if tests?, do: "--lib #{out}"} #{MixGleam.find_libs()}"
      @shell.info("Compiling #{files} #{if tests?, do: "test "}file#{if 1 != files, do: "s"} (.gleam)")
      MixGleam.IO.debug_info("Compiler Command", cmd)
      compiled? =
        @shell.cmd(cmd)
        |> Kernel.===(0)
      if compiled? do
        # TODO remove when `gleam` handles this
        include =
          Path.dirname(out)
          |> Path.join("include")
        File.mkdir_p(include)
        Path.join(out, "**/*.hrl")
        |> Path.wildcard
        |> Enum.each(&File.cp(&1, Path.join(include, Path.basename(&1))))

        if not tests? and Mix.env() in [:dev, :test] do
          compile_package(app, true)
        end
      else
        raise MixGleam.Error, message: "Compilation failed with command:\n\n#{cmd}"
      end
    end
    :ok
  end
end
