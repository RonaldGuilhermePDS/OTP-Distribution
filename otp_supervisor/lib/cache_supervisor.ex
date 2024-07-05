defmodule CacheSupervisor do
  use DynamicSupervisor

  def init(_) do
    {:ok, nil}
  end

  def start_link(_) do
    DynamicSupervisor.start_link(name: __MODULE__, strategy: :one_for_one)
  end

  def start_child() do
    DynamicSupervisor.start_child(__MODULE__, { Cache, [%{}] })
  end
end
