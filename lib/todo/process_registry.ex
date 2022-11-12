defmodule Todo.ProcessRegistry do
  use GenServer
  import Kernel, except: [send: 2]

  def init(_) do
    IO.inspect("creando registro de procesos")
    {:ok, nil}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: :process_registry)
  end

  def send(key, message) do
    case whereis_name(key) do
      :undefined -> {:badarg, {key, message}}
      pid ->
        Kernel.send(pid, message)
        pid

    end
  end

  def register_name(key, pid) do
    case :ets.lookup(:registries, key) do
      [] ->
        GenServer.call(:process_registry, {:register_name, key, pid})

      [{_key, pid}] ->
        pid
    end
  end

  def whereis_name(key) do
    GenServer.call(:process_registry, {:whereis_name, key})
  end

  def unregister_name(key) do
    GenServer.call(:ets_table, {:unregister_worker, key})
  end

  def handle_call({:register_name, key, pid}, _, state) do
    case :ets.lookup(:registries, key) do
      [] ->
        Process.monitor(pid)
        GenServer.call(:ets_table, {:insert_register, key, pid})
        {:reply, :yes, state}
      [{_key, _pid}] ->
        {:reply, :no, state}
    end
  end

  def handle_call({:whereis_name, key}, _, state) do
    pid = case :ets.lookup(:registries, key) do
      [] ->
        :undefined
      [{_key, pid}] ->
        pid
    end

    {:reply, pid, state}
  end

  def handle_info({:DOWN, _, :process, pid, _}, state) do
    GenServer.call(:ets_table, {:deregister_pid, pid})
    {:noreply, state}
  end

  def via_tuple(type, name) do
    {:via, __MODULE__ , {type, name}}
  end
end
