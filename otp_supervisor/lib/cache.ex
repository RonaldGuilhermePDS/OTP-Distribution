defmodule Cache do
  use GenServer
  require Logger

  def init(_) do
    {:ok, %{node: node()}}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: { :global, __MODULE__ })
    |> case do
      {:ok, pid} ->
        node_one = __MODULE__.get()[:node]
        Logger.info("Start cache on #{node_one}")
        {:ok, pid}
      {:error, _} ->
        node_one = __MODULE__.get()[:node]
        Logger.warning("Cache already started on #{node_one}")
        {:ok, nil}
    end
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({ :put, key, value }, state) do
    state = Map.put(state, key, value)
    {:noreply, state}
  end

  def get, do: GenServer.call({ :global, __MODULE__ }, :get)
  def put(key, value), do: GenServer.cast({ :global, __MODULE__ }, { :put, key, value })
end
