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
        term
        |> String.downcase()
        |> String.trim()
        |> Zoo.Dictionary.search_vocabulary()
        |> Enum.map(fn item ->
          Map.take(item, [:term, :phonetic, :brief_meaning])
        end)
      else
        []
      end

    {:noreply, assign(socket, keyword: term, suggestions: suggestions, searching: true)}
  end

  def handle_event("search", _session, socket) do
    {:noreply, do_search(socket)}
  end

  defp do_search(socket) do
    term = String.trim(socket.assigns.keyword || "")

    if String.length(term) > 0 do
      term
      |> String.downcase()
      |> Zoo.Dictionary.get_vocabolary()
      |> case do
        {:error, _} ->
          assign(socket, result: nil, searching: false)

        {:ok, result} ->
          result = Zoo.Helpers.StructHelper.to_map(result)
          assign(socket, result: result, searching: false)
      end
    else
      assign(socket, result: nil, searching: false)
    end
  end
end
