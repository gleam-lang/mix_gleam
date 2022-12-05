defmodule Mix.Tasks.Gleam.Deps.Get do
  use Mix.Task

  @recursive true

  @shell Mix.shell()

  @moduledoc """
  Extends the task of getting dependencies.

  This task recursively ensures that all subdependencies are fetched in preparation for
  compiling them from Gleam into Erlang, a task that should happen prior to Mix's compilation.

  Include this task in your project's `mix.exs` with, e.g.:

      def project do
        [
          aliases: ["deps.get": ["deps.get", "gleam.deps.get"]],
        ]
      end

  """

  @impl true
  def run(args) do
    MixGleam.IO.debug_info("Deps.Get Start")

    deps =
      Mix.Dep.load_and_cache()
      |> Enum.map(fn %Mix.Dep{app: app, opts: opts, manager: manager} = dep ->
        cmd? = fn -> not is_nil(opts[:compile]) end
        managed? = fn -> not is_nil(manager) end

        unless managed?.() or cmd?.() do
          Mix.Dep.in_dependency(dep, fn _module ->
            mix? = fn -> File.exists?("mix.exs") end

            unless mix?.() or not MixGleam.gleam?(dep) do
              @shell.info("Adding mix.exs")
              config = MixGleam.get_config()
              version = Map.get(config, :version, "0.1.0")

              deps =
                Map.get(config, :dependencies, %{})
                |> Map.to_list()

              dev_deps =
                Map.get(config, :"dev-dependencies", %{})
                |> Map.to_list()
                |> Enum.map(&Tuple.append(&1, only: [:dev, :test], runtime: false))

              deps = deps ++ dev_deps
              # TODO use eex template
              File.write!("mix.exs", MixGleam.Config.render_mix(app, version, deps))
              :cont
            else
              :halt
            end
          end)
        else
          :halt
        end
      end)

    if :cont in deps do
      @shell.info("Rerunning deps.get...")
      Mix.Task.rerun("deps.get", args)
      Mix.Task.rerun("gleam.deps.get", args)
    end

    MixGleam.IO.debug_info("Deps.Get End")
  end
end
