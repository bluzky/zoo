defmodule ZooWeb.Base64Live.Index do
  use ZooWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, input: nil, output: nil, error: nil, url_safe: false)}
  end

  def handle_event("input_changed", %{"input" => input} = session, socket) do
    {:noreply, assign(socket, input: input, error: nil, url_safe: session["url_safe"] || false)}
  end

  def handle_event("encode", _session, socket) do
    input = socket.assigns.input || ""

    output =
      if socket.assigns.url_safe do
        Base.encode64(input)
      else
        Base.url_encode64(input)
      end

    {:noreply, assign(socket, :output, output)}
  end

  def handle_event("decode", _, socket) do
    input = socket.assigns.input

    result =
      if socket.assigns.url_safe do
        Base.url_decode64(input)
      else
        Base.decode64(input)
      end

    case result do
      {:ok, output} ->
        {:noreply, assign(socket, :output, output)}

      _ ->
        {:noreply, assign(socket, output: nil, error: "invalid base64 string")}
    end
  end
end
