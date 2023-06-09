defmodule ToDoList.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ToDoListWeb.Telemetry,
      # Start the Ecto repository
      ToDoList.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ToDoList.PubSub},
      # Start Finch
      {Finch, name: ToDoList.Finch},
      # Start the Endpoint (http/https)
      ToDoListWeb.Endpoint,
      ToDoList.CronjobTasks
      # Start a worker by calling: ToDoList.Worker.start_link(arg)
      # {ToDoList.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ToDoList.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ToDoListWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
