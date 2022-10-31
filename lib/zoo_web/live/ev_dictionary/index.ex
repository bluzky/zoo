defmodule ZooWeb.EvDictionaryLive.Index do
  use ZooWeb, :live_view
  alias Zoo.EvDictionary.DictionaryService

  def mount(_params, _session, socket) do
    {:ok, assign(socket, keyword: nil, result: nil, suggestions: [], searching: false)}
  end

  def handle_event("input_changed", %{"keyword" => keyword} = session, socket) do
    # search for suggestion
    suggestions = [
      %{
        word: "abc",
        meaning: "hello abc"
      },
      %{
        word: "def",
        meaning: "define"
      }
    ]

    {:noreply, assign(socket, keyword: keyword, suggestions: suggestions, searching: true)}
  end

  def handle_event("search", _session, socket) do
    keyword = String.trim(socket.assigns.keyword || "")

    DictionaryService.lookup(keyword)
    |> Zoo.Helpers.StructHelper.to_map()
    # |> IO.inspect()
    |> case do
      {:error, _} ->
        {:noreply, assign(socket, result: nil, searching: false)}

      {:ok, result} ->
        {:noreply, assign(socket, result: result, searching: false)}
    end
  end
end
