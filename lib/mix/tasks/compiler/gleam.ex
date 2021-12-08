defmodule Mix.Tasks.Compile.Gleam do
  use Mix.Task.Compiler

  @first_gleam_version_not_taking_build_arg "0.18.0-rc1"

  def run(_args) do
    case Mix.shell().cmd(build_command()) do
      0 -> {:ok, []}
      status -> exit(status)
    end
  end

  defp build_command do
    if build_needs_arg?(),
      do: "gleam build .",
      else: "gleam build"
  end

  defp build_needs_arg? do
    {cmd_output, 0} = System.cmd("gleam", ["-V"])
    <<"gleam "::utf8, active_version::binary>> = String.trim(cmd_output)

    comparison = Version.compare(active_version, @first_gleam_version_not_taking_build_arg)
    comparison == :lt
  end
end
