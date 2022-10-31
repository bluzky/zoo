defmodule Zoo.Helpers.StructHelper do
  def to_map(struct) when is_struct(struct) do
    Map.from_struct(struct)
    |> Enum.map(fn {k, v} ->
      {k, to_map(v)}
    end)
    |> Enum.into(%{})
  end

  def to_map(map) when is_map(map) do
    map
    |> Enum.map(fn {k, v} ->
      {k, to_map(v)}
    end)
    |> Enum.into(%{})
  end

  def to_map(list) when is_list(list) do
    Enum.map(list, fn
      {k, v} when is_atom(k) -> {k, to_map(v)}
      v -> to_map(v)
    end)
  end

  def to_map(any), do: any
end
