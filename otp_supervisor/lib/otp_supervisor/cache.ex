defmodule OtpSupervisor.Cache do
  use GenServer

  def init(_) do
    {:ok, %{node: node()}}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({ :put, key, value }, state) do
    state = Map.put(state, key, value)
    {:noreply, state}
  end

  def get, do: GenServer.call(__MODULE__, :get)
  def put(key, value), do: GenServer.cast(__MODULE__, { :put, key, value })
end
