defmodule Todo.Database do
  use GenServer

  def start_link(db_folder) do
    IO.inspect("Iniciando darabeis")
    GenServer.start_link(Todo.Database, db_folder, name: :database)
  end

  def init(db_folder) do
    File.mkdir_p(db_folder)
    workers =
      Enum.map(0..2, fn n ->
        {:ok, worker} = Todo.DatabaseWorker.start_link(db_folder)
        IO.puts(["Trabajo Trabajo!", "No soy esa clase de orco", "Mas trabajo?", "Si mi rey?"] |> Enum.random())
        {n, worker}
      end)
      |> Map.new()

    {:ok, workers}
  end

  def store(key, data) do
    GenServer.cast(:database, {:store, key, data})
  end

  def get(key) do
    GenServer.call(:database, {:get, key})
  end

  def handle_cast({:store, key, data}, workers) do
    worker =
      get_worker(key, workers)
    GenServer.cast(worker, {:store, key, data})

    {:noreply, workers}
  end

  def handle_call({:get, key}, caller, workers) do
    spawn( fn  ->
      worker =
        get_worker(key, workers)
        |> IO.inspect(label: Enum.random(["Dejame dormir!", "No quiero!!", "Pedicelo a nº #{:rand.uniform(3)}", "Más trabajo?"]))
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
