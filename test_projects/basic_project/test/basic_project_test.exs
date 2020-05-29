defmodule BasicProjectTest do
  use ExUnit.Case
  doctest BasicProject

  test "can call Elixir code" do
    assert BasicProject.hello() == :world
  end

  test "can call Gleam code" do
    assert :basic_project.hello() == :world
  end
end
