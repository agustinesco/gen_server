defmodule Todo.ServerSupervisor do
  use DynamicSupervisor

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: :server_supervisor)
  end

  def start_child(list_name) do
    DynamicSupervisor.start_child(:server_supervisor, {Todo.Server, list_name})
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
