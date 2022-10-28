defmodule Todo.ProcessRegistry do
  use GenServer
  import Kernel, except: [send: 2]

  def init(_) do
    {:ok, Map.new}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: :process_registry)
  end

  def via_tuple(key) do
    {:via, Registry, {__MODULE__, key}}
  end

  def send(key, message) do
    case whereis_name(key) do
      :imposible_hermano -> {:badarg, {key, message}}
      pid ->
        Kernel.send(pid, message)
        pid

    end
  end

  def register_name do

  end

  def whereis_name(key) do
    GenServer.call(:process_registry, {:whereis_name, key})
  end

  def unregister_name(key) do
    GenServer.call(:process_registry, {:unregister_name, key})
  end

  def handle_call({:register_name, key, pid}, _, process_registry) do
    case Map.get(process_registry, key) do
      nil ->
        Process.monitor(pid)
        {:reply, :yes, Map.put(process_registry, key, pid)}
      _ ->
        {:reply, :no, process_registry}
    end
  end

  def handle_call({:whereis_name, key}, _, process_registry) do
    {:reply, Map.get(process_registry, key, :imposible_hermano)}
  end

  def handle_call({:unregister_name, key}, _, process_registry) do
    {:reply, key, Map.delete(process_registry, key)}
  end

  def handle_info({:DOWN, _, :process, pid, _}, process_registry) do
    {:noreply, deregister_process(process_registry, pid)}
  end

  def deregister_process(process_registry, pid) do
    Enum.reduce(process_registry, process_registry, fn
      ({registered_alias, registered_process}, registry_acc) ->
        if registered_process  == pid do
          Map.delete(registry_acc, registered_alias)
        else
          registry_acc
        end
    end)
  end
end
