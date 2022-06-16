defmodule MixGleam do
  @search_paths_gleam ["*{src,lib}"]
  @query_gleam "**/*.gleam"

  @search_paths_erl [
    "build/dev/erlang/*/build",
    "src",
  ]
  @query_erl "**/*.erl"

  @moduledoc """
  TODO

  """

  def gleam?(%Mix.Dep{manager: manager} = dep) do
    :gleam == manager or is_nil(manager) and Mix.Dep.in_dependency(dep, fn _module ->
      File.regular?("gleam.toml")
    end)
  end

  @deprecated "Please prepend :gleam to :compilers and add :\"deps.get\" to :aliases following mix_gleam README.md instead"
  def add_aliases(aliases \\ []) do
    aliases
    |> MixGleam.Aliases.append(["deps.get": ["gleam.deps.get"]])
    |> MixGleam.Aliases.prepend(["compile.all": ["compile.gleam"]])
  end

  def get_config(path \\ "gleam.toml") do
    if File.regular?(path) do
      # TODO replace with `gleam ...` tooling
      MixGleam.Config.get!(path)
    else
      nil
    end
  end

  def find_libs(search_paths \\ @search_paths_erl, query \\ @query_erl) do
    Mix.Project.deps_paths()
    |> Enum.map(&elem(&1, 1))
    |> find_paths(search_paths, query)
    |> Stream.map(&"--lib #{&1}")
    |> Enum.join(" ")
  end

  def find_paths(apps_paths \\ [""], search_paths \\ @search_paths_gleam, query \\ @query_gleam) do
    search_paths =
      apps_paths
      |> Enum.flat_map(fn path ->
        search_paths
        |> Stream.map(&Path.join(path, &1))
        |> Enum.flat_map(&Path.wildcard/1)
      end)

    find_files(search_paths, query)
    |> Stream.map(&Path.dirname/1)
    |> Stream.uniq
    |> Stream.map(fn path ->
      search_paths
      |> Enum.find(&String.starts_with?(path, &1))
    end)
    |> Enum.uniq
  end

  def find_files(search_paths \\ @search_paths_gleam, query \\ @query_gleam) do
    search_paths
    |> Stream.flat_map(&Path.wildcard(Path.join(&1, query)))
    |> Enum.uniq
  end
end
