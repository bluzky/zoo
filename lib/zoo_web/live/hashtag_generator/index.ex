defmodule ZooWeb.HashtagGeneratorLive.Index do
  use ZooWeb, :live_view

  @default_options %{
    "remove_accent" => "true",
    "capitalize_first_character" => nil,
    "remove_whitespace" => nil
  }

  def mount(_params, _session, socket) do
    {:ok, assign(socket, input: nil, output: nil, options: @default_options)}
  end

  def handle_event("input_changed", %{"input" => input} = session, socket) do
    {:noreply,
     assign(socket, input: input, options: session["options"] || socket.assigns.options)}
  end

  def handle_event("generate", _session, socket) do
    input = socket.assigns.input || ""
    output = generate_hashtag(input, socket.assigns.options)
    {:noreply, assign(socket, :output, output)}
  end

  defp generate_hashtag(input, options) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&text_to_hashtag(&1, options))
      |> Enum.filter(&(not is_nil(&1) and &1 != ""))
      |> Enum.join(", ")
    end)
    |> Enum.join("\n")
  end

  defp text_to_hashtag(text, options) do
    # IO.inspect(options)
    text = String.trim(text)

    text =
      if options["capitalize_first_char"] do
        text
        |> String.split()
        |> Enum.map(&String.capitalize(&1))
        |> Enum.join(" ")
      else
        text
      end

    text =
      if options["remove_whitespace"] do
        String.replace(text, " ", "")
      else
        text
      end

    text =
      if options["remove_accent"] do
        Slugger.slugify(text, ?_)
      else
        text
      end

    if text != "" do
      "#" <> text
    end
  end
end
