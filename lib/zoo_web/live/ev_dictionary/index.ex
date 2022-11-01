defmodule ZooWeb.EvDictionaryLive.Index do
  use ZooWeb, :live_view
  alias Zoo.EvDictionary.DictionaryService

  def mount(_params, _session, socket) do
    {:ok, assign(socket, keyword: nil, result: nil, suggestions: [], searching: false)}
  end

  def handle_params(params, _uri, socket) do
    term = params["term"]

    {:noreply, do_search(assign(socket, keyword: term))}
  end

  def handle_event("input_changed", %{"keyword" => term}, socket) do
    suggestions =
      if String.length(term) > 2 do
        DictionaryService.suggest(term)
        |> Enum.sort_by(&String.length/1)
        |> Enum.take(10)
        |> Enum.map(fn word ->
          case DictionaryService.lookup(word) do
            {:ok, term} -> term
            _ -> nil
          end
        end)
        |> Enum.reject(&is_nil/1)
        |> render_suggestion()
      else
        []
      end

    {:noreply, assign(socket, keyword: term, suggestions: suggestions, searching: true)}
  end

  def handle_event("search", _session, socket) do
    {:noreply, do_search(socket)}
  end

  defp do_search(socket) do
    keyword = String.trim(socket.assigns.keyword || "")

    DictionaryService.lookup(keyword)
    |> Zoo.Helpers.StructHelper.to_map()
    # |> IO.inspect()
    |> case do
      {:error, _} ->
        assign(socket, result: nil, searching: false)

      {:ok, result} ->
        assign(socket, result: result, searching: false)
    end
  end

  defp render_suggestion(terms) do
    Enum.map(terms, fn term ->
      section = List.first(term.sections)
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
        translation: (meaning && meaning.translation) || nil
      }
    end)
  end
end
