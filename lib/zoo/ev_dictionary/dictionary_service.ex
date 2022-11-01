defmodule Zoo.EvDictionary.DictionaryService do
  alias Zoo.EvDictionary.Index
  alias Zoo.EvDictionary.Bucket
  alias Zoo.EvDictionary.StardictParser
  alias Zoo.EvDictionary.Term
  require Logger
  @dict_path "priv/data/stardict_en_vi.txt.gz"

  def start_link(_args \\ []) do
    Task.start_link(fn ->
      :timer.sleep(200)
      load(Application.app_dir(:zoo, @dict_path))
    end)
  end

  def load(path) do
    Logger.info("Loading dictionary ....")

    File.stream!(path, [:compressed])
    |> Stream.with_index()
    |> Stream.map(fn {line, _index} ->
      # IO.inspect(index)
      StardictParser.parse(line)
    end)
    |> Stream.reject(&is_nil/1)
    |> Stream.map(fn term ->
      Index.add(term.term)
      Bucket.put(term.term, Term.flatten(term))
    end)
    # |> Stream.take(10000)
    |> Stream.run()

    Logger.info("Loading dictionary compeleted")
  end

  def suggest(term) do
    Index.search(term)
  end

  def lookup(term) do
    case Bucket.get(term) do
      {:ok, data} -> {:ok, Term.new(data)}
      error -> error
    end
  end
end
