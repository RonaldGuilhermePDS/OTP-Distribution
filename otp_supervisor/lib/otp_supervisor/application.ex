defmodule OtpSupervisor.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Bandit, plug: OtpSupervisor.Router, scheme: :http}
    ]
    opts = [strategy: :one_for_one, name: OtpSupervisor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
