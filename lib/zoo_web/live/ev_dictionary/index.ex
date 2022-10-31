defmodule ZooWeb.EvDictionaryLive.Index do
  use ZooWeb, :live_view

  @result %{
    word: "hello",
    pronunciation: "hello /hello/",
    groups: [
      %{
        type: "noun",
        list: [
          %{
            meaning: "xin chao",
            examples: [["hello you", "chao ban"], ["hello word", "chao the gioi"]]
          },
          %{
            meaning: "xin chao",
            examples: [["hello you", "chao ban"], ["hello word", "chao the gioi"]]
          },
          %{
            meaning: "xin chao",
            examples: [["hello you", "chao ban"], ["hello word", "chao the gioi"]]
          }
        ]
      },
      %{
        type: "noun",
        list: [
          %{
            meaning: "xin chao",
            examples: [["hello you", "chao ban"], ["hello word", "chao the gioi"]]
          }
        ]
      }
    ]
  }
  def mount(_params, _session, socket) do
    {:ok, assign(socket, keyword: nil, result: @result, suggestions: [], searching: false)}
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
    keyword = socket.assigns.keyword || ""

    {:noreply, assign(socket, result: @result, searching: false)}
  end
end
