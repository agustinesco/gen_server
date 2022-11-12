defmodule Todo.EtsTable do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: :ets_table)
  end

  def init(_) do
    IO.inspect("Creando ets table")
    :ets.new(:registries, [:set, :protected, :named_table])

    {:ok, nil}
  end

  def handle_call({:insert_register, key, pid}, _, state) do
    :ets.insert(:registries, {key, pid})

    {:reply, {key, pid},state}
  end

  def handle_call({:deregister_pid, pid}, _, state) do
    :ets.match_delete(:registries, {:_, pid})

    {:reply, pid, state}
  end

  def handle_call({:unregister_worker, key}, _, state) do
    :ets.delete(:registries, key)

    {:reply, key,state}
  end
end
