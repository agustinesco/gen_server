defmodule Todo.PoolSupervisor do
  use Supervisor

  def init({db_folder, pool_size}) do
    workers = Enum.map(1..pool_size, fn worker_number ->
      %{
        id: {:database_worker, worker_number},
        start: {Todo.DatabaseWorker, :start_link, [db_folder, worker_number]}
      }
      end)
      Supervisor.init(workers, strategy: :one_for_one)
  end

  def start_link(db_folder, pool_size) do
    Supervisor.start_link(__MODULE__, {db_folder, pool_size})
  end
end
