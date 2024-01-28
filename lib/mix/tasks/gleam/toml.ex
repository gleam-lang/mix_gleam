defmodule Mix.Tasks.Gleam.Toml do
  use Mix.Task
  @impl true
  @shell Mix.shell()
  def run(argv) do
    replace =
      argv
      |> OptionParser.parse!(switches: [replace: :boolean])
      |> elem(0)
      |> Keyword.get(:replace, false)

    Mix.Project.get!()
    cfg = Mix.Project.config()

    deps =
      Mix.Dep.load_and_cache()
      |> Enum.flat_map(fn %Mix.Dep{app: dep, opts: opts} ->
        dst = Keyword.fetch!(opts, :dest)

        if dst |> Path.join("gleam.toml") |> File.regular?() do
          [{dep, [path: dst]}]
        else
          []
        end
      end)

    toml =
      [
        name: Keyword.fetch!(cfg, :app),
        version: Keyword.fetch!(cfg, :version),
        dependencies: deps
      ]
      |> mk_toml

    if replace do
      Mix.Project.project_file()
      |> Path.dirname()
      |> Path.join("gleam.toml")
      |> File.write!(toml)
    else
      @shell.info(toml)
    end
  end

  defp mk_toml(x) do
    x
    |> Enum.map(&mk_toml_row/1)
    |> Enum.join("\n")
  end

  defp mk_toml_row({k, v}), do: "#{mk_toml_key(k)} = #{mk_toml_val(v)}"

  defp mk_toml_key(x) when is_atom(x) or is_binary(x) or is_number(x) do
    x |> to_string |> inspect
  end

  defp mk_toml_val(x) do
    cond do
      is_map(x) or Keyword.keyword?(x) ->
        "{#{x |> Enum.map(&mk_toml_row/1) |> Enum.join(",")}}"

      is_list(x) ->
        "[#{x |> Enum.map(&mk_toml_val/1) |> Enum.join(",")}]"

      is_number(x) ->
        to_string(x)

      true ->
        mk_toml_key(x)
    end
  end
end
