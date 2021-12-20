defmodule Mix.Tasks.Gleam.New do
  use Mix.Task

  @shell Mix.shell()

  @moduledoc """
  This task is UNIMPLEMENTED for now.

  Please use `mix new` and adjust your project's `mix.exs` file using the template
  that follows this help message.

  In the future:

  Creates a new Gleam project. It expects the path of the project as argument.

      mix gleam.new PATH [--app APP] [--module MODULE] [--sup] [--umbrella]

  A project at the given PATH will be created. The application name and module name will be
  retrieved from the path, unless --module or --app is given.

  See `mix help new` for further information.

  """

  @switches [
    # TODO
  ]

  @impl true
  def run(args) do
    MixGleam.IO.debug_info("New Start")

    # TODO
    case OptionParser.parse(args, switches: @switches) do

      {_options, tail, _} -> tail
    end

    Mix.Tasks.Help.run(["gleam.new"])
    @shell.info("\n## Example `mix.exs` follows:\n")
    @shell.info(MixGleam.Config.render_mix(:my_gleam_app))

    MixGleam.IO.debug_info("New End")
  end
end
