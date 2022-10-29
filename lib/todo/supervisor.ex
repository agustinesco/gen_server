defmodule Todo.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(_) do
  children = [
    %{
      id: Todo.ProcessRegistry,
      start: {Todo.ProcessRegistry, :start_link, [[]]},
      type: :worker
    },
    %{
      id: Todo.Database,
      start: {Todo.Database, :start_link, ["./persist/"]},
      type: :supervisor
    },
    %{
      id: Todo.Cache,
      start: {Todo.Cache, :start_link, [[]]},
      type: :worker
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
