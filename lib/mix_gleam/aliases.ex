defmodule MixGleam.Aliases do
  @moduledoc false

  def append(aliases, [{key, items}]) do
    aliases
    |> Keyword.update(key, ["#{key}" | items], &(drop(&1, items) ++ items))
  end

  def prepend(aliases, [{key, items}]) do
    aliases
    |> Keyword.update(key, items ++ ["#{key}"], &(items ++ drop(&1, items)))
  end

  def replace(aliases, [{key, fun}]) do
    aliases
    |> Keyword.update(key, fun, &(drop(&1, fun) ++ fun))
  end

  def drop(aliases, items) do
    aliases
    |> Enum.reject(&(&1 in items))
  end
end
