defmodule Zoo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      # Zoo.Repo,
      # Start the Telemetry supervisor
      ZooWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Zoo.PubSub},
      # Start the Endpoint (http/https)
      ZooWeb.Endpoint,
      Zoo.EvDictionary.Bucket,
      Zoo.EvDictionary.Index,
      %{
        id: Zoo.EvDictionary.DictionaryService,
        start: {Zoo.EvDictionary.DictionaryService, :start_link, []},
        restart: :temporary
      }
      # Start a worker by calling: Zoo.Worker.start_link(arg)
      # {Zoo.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Zoo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ZooWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
