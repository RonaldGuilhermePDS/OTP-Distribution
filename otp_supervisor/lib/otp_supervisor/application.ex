defmodule OtpSupervisor.Application do
  alias Hex.Netrc.Cache
  use Application

  @impl true
  def start(_type, _args) do
    port = System.get_env("PORT", "4000") |> String.to_integer()

    topologies = [
      OtpSupervisor: [
        strategy: Cluster.Strategy.LocalEpmd,
        config: [hosts: ["node@node_one", "node@node_two"]]
      ]
    ]

    children = [
      {Cluster.Supervisor, [topologies, [name: OtpSupervisor.ClusterSupervisor]]},
      {CacheSupervisor, []},
      {Bandit, plug: OtpSupervisor.Router, scheme: :http, port: port}
    ]

    opts = [strategy: :one_for_one, name: OtpSupervisor.Supervisor]

    supervisor_state = Supervisor.start_link(children, opts)

    :timer.sleep(:rand.uniform(1000))
    CacheSupervisor.start_child()

    spawn fn ->
      :net_kernel.monitor_nodes(:true, %{ nodedown_reason: true })
      monitor()
    end
    supervisor_state
  end

  def monitor() do
    receive do
      {:nodedown, _, _} ->
        :timer.sleep(:rand.uniform(1000))
        if !is_pid(:global.whereis_name(Cache)), do:
          CacheSupervisor.start_child()
      _ -> nil
    end
    monitor()
  end
end
