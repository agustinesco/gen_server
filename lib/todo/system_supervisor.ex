defmodule Todo.SystemSupervisor do
  use Supervisor

  @db_workers_pool_size 3

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(_) do
  children = [
    %{
      id: Todo.PoolSupervisor,
      start: {Todo.PoolSupervisor, :start_link, ["./persist/", @db_workers_pool_size]},
      type: :supervisor
    },
    %{
      id: Todo.ServerSupervisor,
      start: {Todo.ServerSupervisor, :start_link, [[]]},
      type: :supervisor
    }
  ]

  Supervisor.init(children, strategy: :one_for_one)
  end
end
