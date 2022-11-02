defmodule Zoo.Repo do
  use Ecto.Repo,
    otp_app: :zoo,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query, only: [limit: 2]

  def preload_stream(stream, size \\ 50, preloads) do
    stream
    |> Stream.chunk_every(size)
    |> Stream.flat_map(fn chunk ->
      __MODULE__.preload(chunk, preloads)
    end)
  end

  def find(query_or_module, filters, opts \\ []) do
    found =
      query_or_module
      |> Filtery.apply(filters)
      |> limit(1)
      |> __MODULE__.one(opts)

    if is_nil(found) do
      {:error, :not_found}
    else
      {:ok, found}
    end
  end

  def list(query_or_module, filters, opts \\ []) do
    query_or_module
    |> Filtery.apply(filters)
    |> __MODULE__.all(opts)
  end
end
