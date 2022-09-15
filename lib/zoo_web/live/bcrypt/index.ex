defmodule ZooWeb.BcryptLive.Index do
  use ZooWeb, :live_view

  @old_prefix "2a"
  @new_prefix "2b"
  @log_rounds 12

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       input: "",
       hash: "",
       error: nil,
       prefix: @new_prefix,
       log_rounds: @log_rounds,
       success: nil
     )}
  end

  def handle_event("input_changed", %{"input" => input} = session, socket) do
    {:noreply,
     assign(socket,
       input: input,
       error: nil,
       success: nil,
       prefix: session["prefix"] || socket.assigns.prefix,
       log_rounds: session["log_rounds"] || socket.assigns[:log_rounds],
       hash: session["hash"] || socket.assigns.hash
     )}
  end

  def handle_event("hash", _session, socket) do
    input = socket.assigns.input || ""
    prefix = socket.assigns.prefix

    log_rounds =
      socket.assigns[:log_rounds]
      |> to_string
      |> String.to_integer()

    output =
      if prefix == @old_prefix do
        Bcrypt.Base.hash_password(input, Bcrypt.Base.gen_salt(log_rounds, true))
      else
        Bcrypt.hash_pwd_salt(input, log_rounds: log_rounds)
      end

    {:noreply, assign(socket, :hash, output)}
  end

  def handle_event("verify", _, socket) do
    input = socket.assigns.input
    hash = socket.assigns.hash

    if Bcrypt.verify_pass(input, hash) do
      {:noreply, assign(socket, success: "password matched")}
    else
      {:noreply, assign(socket, error: "password does not match")}
    end
  end
end
