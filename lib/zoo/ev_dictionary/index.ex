defmodule Zoo.EvDictionary.Index do
  use GenServer
  alias Zoo.EvDictionary.Trie
  # Callbacks

  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, %Trie{}}
  end

  # add term to index tree
  def add(term) do
    GenServer.cast(__MODULE__, {:add, term})
  end

  # list all terms with given prefix
  def search(prefix) do
    GenServer.call(__MODULE__, {:search, prefix})
  end

  @impl true
  def handle_call({:search, prefix}, _from, state) do
    terms = Trie.search(state, prefix)
    {:reply, terms, state}
  end

  @impl true
  def handle_cast({:add, term}, state) do
    {:noreply, Trie.add(state, term)}
  end
end
