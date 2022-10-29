defmodule Todo.Database do
  @pool_size 3

  def start_link(db_folder) do
    Todo.PoolSupervisor.start_link(db_folder, @pool_size)
  end

  def store(key, data) do
    get_worker(key)
    |> Todo.DatabaseWorker.store(key, data)
  end

  def get(key) do
    get_worker(key)
    |> Todo.DatabaseWorker.get(key)
  end

  defp get_worker(key) do
    :erlang.phash2(key, @pool_size) + 1
  end
end
