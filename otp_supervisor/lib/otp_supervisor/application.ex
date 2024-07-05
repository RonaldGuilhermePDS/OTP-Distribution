defmodule OtpSupervisor.Application do
  use Application

  @impl true
  def start(_type, _args) do
    { port, _} = System.get_env("PORT", "4000") |> Integer.parse()

    topologies = [
      OtpSupervisor: [
        strategy: Cluster.Strategy.LocalEpmd,
        config: [hosts: [:"node_one@127.0.0.1", :"node_two@127.0.0.1"]]
      ]
    ]

    children = [
      {
        Cluster.Supervisor,
        [topologies, [name: OtpSupervisor.ClusterSupervisor]]
      },
      {
        OtpSupervisor.Cache, []
      },
      {
        Bandit,
        plug: OtpSupervisor.Router,
        scheme: :http,
        port: port
      },
    ]
    opts = [strategy: :one_for_one, name: OtpSupervisor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
