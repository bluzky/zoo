defmodule ZooWeb.Base64Live.Index do
  use ZooWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, input: nil, output: nil, error: nil)}
  end

  def handle_event("input_changed", %{"input" => input}, socket) do
    {:noreply, assign(socket, :input, input)}
  end

  def handle_event("encode", _session, socket) do
    input = socket.assigns.input || ""
    socket = assign(socket, :output, Base.encode64(input))
    {:noreply, socket}
  end

  def handle_event("decode", _, socket) do
    input = socket.assigns.input

    case Base.decode64(input) do
      {:ok, output} ->
        {:noreply, assign(socket, :output, output)}

      _ ->
        {:noreply, assign(socket, output: nil, error: "invalid base64 string")}
    end
  end
end
