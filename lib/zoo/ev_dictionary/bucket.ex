defmodule Zoo.EvDictionary.Bucket do
  use GenServer
  alias :ets, as: Ets

  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def put(key, value) do
    GenServer.cast(__MODULE__, {:put, key, value, nil})
  end

  @doc """
  Custom TTL for cache entry
  ttl: Time to live in second
  """
  def put(key, value, ttl) do
    GenServer.cast(__MODULE__, {:put, key, value, ttl})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def delete(key) do
    GenServer.cast(__MODULE__, {:delete, key})
  end

  # Server callbacks
  # Server (callbacks)

  @impl true
  def init(state) do
    Ets.new(__MODULE__, [:set, :protected, :named_table])
    {:ok, state}
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    rs = Ets.lookup(__MODULE__, key) |> List.first()

    if rs == nil do
      {:reply, {:error, :not_found}, state}
    else
      expired_at = elem(rs, 2)

      cond do
        is_nil(expired_at) ->
          {:reply, {:ok, elem(rs, 1)}, state}

        NaiveDateTime.diff(NaiveDateTime.utc_now(), expired_at) > 0 ->
          {:reply, {:error, :expired}, state}

        true ->
          {:reply, {:ok, elem(rs, 1)}, state}
      end
    end
  end

  @doc """
  Default TTL 
  """
  @impl true
  def handle_cast({:put, key, val, nil}, state) do
    Ets.insert(__MODULE__, {key, val, nil})
    {:noreply, state}
  end

  @impl true
  def handle_cast({:put, key, val, ttl}, state) do
    inserted_at =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.add(ttl, :second)

    Ets.insert(__MODULE__, {key, val, inserted_at})
    {:noreply, state}
  end

  @impl true
  def handle_cast({:delete, key}, state) do
    Ets.delete(__MODULE__, key)
    {:noreply, state}
  end
end
