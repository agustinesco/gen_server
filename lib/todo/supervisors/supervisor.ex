defmodule Todo.Supervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(_) do
  children = [
    %{
      id: Todo.EtsTable,
      start: {Todo.EtsTable, :start_link, [nil]},
      type: :worker
    },
    %{
      id: Todo.ProcessRegistry,
      start: {Todo.ProcessRegistry, :start_link, [nil]},
      type: :worker
    },
    %{
      id: Todo.SystemSupervisor,
      start: {Todo.SystemSupervisor, :start_link, []},
      type: :supervisor
    }
  ]

  Supervisor.init(children, strategy: :rest_for_one)
  end
end
