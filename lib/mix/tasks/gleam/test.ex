defmodule Mix.Tasks.Gleam.Test do
  use Mix.Task

  @shortdoc "Runs Gleam and Erlang tests"
  @recursive true

  @shell Mix.shell()

  @moduledoc """
  Runs the project Gleam and Erlang tests.

  This task runs the `main` function from your project's `_test.gleam` file.

      // In test/yourapp_test.gleam
      import gleeunit

      pub fn main() {
        gleeunit.main()
      }

  It requires `gleeunit` in your `mix.exs` deps.

      defp deps() do
      # ...
        {:gleeunit, "~> 0.5", only: [:dev, :test], runtime: false},
      end

  """

  @impl true
  def run(_args) do
    MixGleam.IO.debug_info("Test Start")

    # TODO warn Mix.env()

    app =
      Mix.Project.config()
      |> Keyword.get_lazy(:app, fn ->
        raise MixGleam.Error, message: "Unable to find app name"
      end)

    module = String.to_atom("#{app}_test")

    Mix.Task.run("compile")
    Mix.Task.run("app.start")
    @shell.info("Running #{module}.main")
    module.main()

    MixGleam.IO.debug_info("Test End")
  end
end
