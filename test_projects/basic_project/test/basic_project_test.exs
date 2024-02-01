defmodule BasicProjectTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest BasicProject

  test "can call Elixir code" do
    assert BasicProject.hello() == :world
  end

  test "can call Gleam code" do
    assert :basic_project.hello() == :world
  end

  test "can call Gleam library" do
    assert :gleam@list.reverse([1, 2, 3]) == [3, 2, 1]
  end

  test "gleam.toml mix task" do
    lhs = """
    "name" = "basic_project"
    "version" = "0.1.0"
    "dependencies" = {"gleam_stdlib" = {"path" = "deps/gleam_stdlib"}, "gleeunit" = {"path" = "deps/gleeunit"}}
    """

    rhs = capture_io(fn -> Mix.Tasks.Gleam.Toml.run([]) end)

    assert lhs == rhs
  end
end
