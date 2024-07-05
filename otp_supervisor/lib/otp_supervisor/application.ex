defmodule OtpSupervisor.Application do
  use Application

  @impl true
  def start(_type, _args) do
    { port , _} = System.get_env("PORT", "4000") |> Integer.parse()

    children = [
      {
        Bandit,
        plug: OtpSupervisor.Router,
        scheme: :http,
        port: port
      },
      {OtpSupervisor.Cache, []}
    ]
    opts = [strategy: :one_for_one, name: OtpSupervisor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
