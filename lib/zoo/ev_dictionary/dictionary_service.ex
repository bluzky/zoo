defmodule Zoo.EvDictionary.DictionaryService do
  alias Zoo.EvDictionary.StardictParser
  require Logger
  @dict_path "priv/data/stardict_en_vi.txt.gz"

  def start_link(_args \\ []) do
    Task.start_link(fn ->
      :timer.sleep(200)
      load(Application.app_dir(:zoo, @dict_path))
    end)
  end

  def load(path \\ nil) do
    Logger.info("Loading dictionary ....")
    path = path || Application.app_dir(:zoo, @dict_path)

    File.stream!(path, [:compressed])
    |> Stream.with_index()
    |> Stream.map(fn {line, _index} ->
      StardictParser.parse(line)
    end)
    |> Stream.reject(&is_nil/1)
    |> Stream.map(fn term ->
      # Index.add(term.term)
      # Bucket.put(term.term, Term.flatten(term))
      term
      |> prepare_data
      |> Zoo.Dictionary.create_vocabolary()
    end)
    # |> Stream.take(10000)
    |> Stream.run()

    Logger.info("Loading dictionary compeleted")
  end

  defp prepare_data(term) do
    section = List.first(term.sections)

    # extract phonetic
    phonetic =
      case Regex.run(~r/.+\/(.+?)\//, section.name) do
        [_, found] -> found
        _ -> nil
      end

    meaning = List.first(section.meanings)

    meaning =
      if is_nil(meaning) do
        word_class = List.first(section.word_classes)

        if word_class do
          List.first(word_class.meanings)
        end
      else
        meaning
      end

    %{
      term: term.term,
      phonetic: phonetic,
      brief_meaning: (meaning && meaning.translation) || nil,
      details: Zoo.Helpers.StructHelper.to_map(term.sections)
    }
  end
end
