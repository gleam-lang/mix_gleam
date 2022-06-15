defmodule MixGleam.Config do
  @version "0.4.0"
  @deps [
    {:gleam_stdlib, "~> 0.18"},
    {:gleeunit, "~> 0.5", only: [:dev, :test], runtime: false},
  ]

  @moduledoc false

  # TODO use eex template
  def render_mix(app, version \\ "0.1.0", deps \\ @deps) do
    ex_ver =
      System.version
      |> Version.parse!

    deps =
      deps
      |> inspect(pretty: true, limit: :infinity, width: 50)
      |> String.replace("\n", "\n    ")

~s(defmodule #{Mix.Utils.command_to_module_name(app)}.MixProject do
  use Mix.Project

  @app :#{app}
  @version "#{version}"

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> #{ex_ver.major}.#{ex_ver.minor}",
      name: "\#{@app}",
      archives: [mix_gleam: "~> #{@version}"],
      compilers: [:gleam] ++ Mix.compilers(\),
      aliases: [
        "deps.get": ["deps.get", "gleam.deps.get"],
      ],
      erlc_paths: ["build/dev/erlang/\#{@app}/build"],
      erlc_include_path: "build/dev/erlang/\#{@app}/include",
      start_permanent: Mix.env(\) == :prod,
      deps: deps(\),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    #{deps}
  end
end)
  end

  # TODO replace with `gleam ...` tooling

  def get!(path \\ "gleam.toml") do
    definition = ~r/\n\s*(?=[#a-z\[])/i

    File.read!(path)
    |> String.split(definition, trim: true)
    |> Stream.map(&tokenize/1)
    |> Stream.reject(&({[], nil} == &1))
    |> Stream.map(&atomize/1)
    |> Stream.map(&parse/1)
    |> structure
  end

  @doc false
  def structure(tokens) do
    tokens
    |> Enum.reduce({[], %{}}, fn {keys, value}, {table, acc} ->
      cond do
        [] == table and not is_nil(value) ->
          {table, nested_update(acc, keys, value)}
        nil == value ->
          {keys, nested_update(acc, keys, %{})}
        true ->
          {table, nested_update(acc, table ++ keys, value)}
      end
    end)
    |> elem(1)
  end

  @doc false
  def nested_update(map, keys, value) do
    keys =
      keys
      |> Enum.map(&Access.key(&1, %{}))
      |> List.replace_at(-1, List.last(keys))

    map
    |> get_and_update_in(keys, &{&1, (if is_nil(&1), do: value, else: &1)})
    |> elem(1)
  end

  @doc false
  def parse(token) do
    case token do
      {_keys, nil} = token -> token

      {keys, value} ->
        value =
          value
          |> Macro.unescape_string
          |> String.replace(~r/^"(.*?)"$/, "\\1")
        {keys, value}
    end
  end

  @doc false
  def atomize({keys, _} = token) do
    dotted_key = ~r/^[^".]*?(\"([^"]*?(\\"|))*?\")*?\K\s*\.\s*/

    split_keys =
      keys
      |> Stream.unfold(fn acc ->
        emit =
          acc
          |> Enum.flat_map(&String.split(&1, dotted_key))
        unless acc == emit do
          {emit, emit}
        else
          nil
        end
      end)
      |> Enum.at(-1)

    keys =
      unless nil == split_keys do
        split_keys
      else
        keys
      end
      |> Enum.map(&String.to_atom/1)

    token
    |> put_elem(0, keys)
  end

  @doc false
  def tokenize(line) do
    table = ~r/^\s*\[([^\]]+?)\s*\]\s*$/
    assignment = ~r/^\s*([^=]+?)\s*=\s*(.+?)\s*$/m
    comment = ~r/^[^"]*?(\"([^"]*?(\\"|))*?\")*?\K\s*#.*$/

    line =
      line
      |> String.replace(comment, "")

    cond do
      match = Regex.run(table, line) ->
        [_, key] = match
        {[key], nil}

      match = Regex.run(assignment, line) ->
        [_, key, value] = match
        {[key], value}

      true -> {[], nil}
    end
  end
end
