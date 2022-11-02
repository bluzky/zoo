defmodule Zoo.Helpers.StructHelper do
  def to_map(struct, opts \\ [])

  def to_map(struct, opts) when is_struct(struct) do
    except = opts[:except] || []

    Map.drop(struct, [:__struct__, :__meta__] ++ except)
    |> Enum.map(fn {k, v} ->
      {k, to_map(v, opts)}
    end)
    |> Enum.into(%{})
  end

  def to_map(map, opts) when is_map(map) do
    map
    |> Enum.map(fn {k, v} ->
      {k, to_map(v, opts)}
    end)
    |> Enum.into(%{})
  end

  def to_map(list, opts) when is_list(list) do
    Enum.map(list, fn
      {k, v} when is_atom(k) -> {k, to_map(v, opts)}
      v -> to_map(v, opts)
    end)
  end

  def to_map(any, _), do: any
end
