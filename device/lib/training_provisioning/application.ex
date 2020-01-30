defmodule TrainingProvisioning.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @spec start(Application.start_type(), any()) :: {:error, any} | {:ok, pid()}
  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TrainingProvisioning.Supervisor]

    children =
      [
        # Children for all targets
        # Starts a worker by calling: TrainingProvisioning.Worker.start_link(arg)
        # {TrainingProvisioning.Worker, arg},
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: TrainingProvisioning.Worker.start_link(arg)
      # {TrainingProvisioning.Worker, arg},
    ]
  end

  def children(_target) do
    []
  end

  def target() do
    Application.get_env(:training_provisioning, :target)
  end
end
