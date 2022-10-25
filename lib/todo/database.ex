defmodule Todo.Database do
  use GenServer

  def start(db_folder) do
    GenServer.start(Todo.Database, db_folder, name: :database_server)
  end

  def init(db_folder) do
    File.mkdir_p(db_folder)
    workers =
      Enum.map(0..2, fn n ->
        {:ok, worker} = GenServer.start(Todo.DatabaseWorker, db_folder)
        {n, worker}
      end)
      |> Map.new()

    {:ok, workers}
  end

  def store(key, data) do
    GenServer.cast(:database_server, {:store, key, data})
  end

  def get(key) do
    GenServer.call(:database_server, {:get, key})
  end

  def handle_cast({:store, key, data}, workers) do
    worker =
      get_worker(key, workers)
    GenServer.cast(worker, {:store, key, data})

    {:noreply, workers}
  end

  def handle_call({:get, key}, caller, workers) do
    IO.inspect(workers)
    spawn( fn  ->
      worker =
        get_worker(key, workers)
        |> IO.inspect(label: :choosen_worker)
      response =
        GenServer.call(worker, {:get, key})

        GenServer.reply(caller, response)
    end)

    {:noreply, workers}
  end

  defp get_worker(key, workers) do
    key = :erlang.phash2(key, 3)
    workers
    |> Map.get(key, workers)
  end
end
