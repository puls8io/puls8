defmodule Puls8.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      Puls8Web.Telemetry,
      # Start the Ecto repository
      Puls8.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Puls8.PubSub},
      # Start Finch
      {Finch, name: Puls8.Finch},
      # Start the Endpoint (http/https)
      Puls8Web.Endpoint
      # Start a worker by calling: Puls8.Worker.start_link(arg)
      # {Puls8.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Puls8.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Puls8Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
