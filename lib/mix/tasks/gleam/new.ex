defmodule Mix.Tasks.Gleam.New do
  use Mix.Task

  @shortdoc "Creates a new Gleam project"

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
    retro: :boolean,
  ]

  @impl true
  def run(args) do
    MixGleam.IO.debug_info("New Start")

    # TODO
    case OptionParser.parse(args, switches: @switches) do
      {options, _tail, _} ->
        retro? = Keyword.get(options, :retro, false)
        unless retro? do
          Mix.Tasks.Help.run(["gleam.new"])
          @shell.info("\n")
          retro()
        end
        if retro?, do: retro()
    end

    MixGleam.IO.debug_info("New End")
  end

  @doc false
  def retro() do
    @shell.info("## Example `mix.exs` follows:\n")
    @shell.info(MixGleam.Config.render_mix(:my_gleam_app))
  end
end
