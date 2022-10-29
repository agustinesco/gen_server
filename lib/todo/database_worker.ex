defmodule Todo.DatabaseWorker do
  use GenServer

  def start_link(db_folder, worker_number) do
    IO.puts("starting database worker ##{worker_number}")
    File.mkdir_p(db_folder)
    GenServer.start_link(__MODULE__, db_folder, name: via_tuple(worker_number))
  end

  def store(worker_number, key, data) do
    GenServer.cast(via_tuple(worker_number), {:store, key, data})
  end

  def get(worker_number, key) do
    GenServer.call(via_tuple(worker_number), {:get, key})
  end

  def handle_cast({:store, key, data}, db_folder) do
    spawn(fn -> file_name(db_folder, key)
      |> File.write!(:erlang.term_to_binary(data))
    end)

    {:noreply, db_folder}
  end

  def handle_call({:get, key}, caller, db_folder) do
      response =
      case File.read(file_name(db_folder, key)) do
        {:ok, content} ->
          :erlang.binary_to_term(content)
        _ ->
          nil
      end
      GenServer.reply(caller, response)

    {:noreply,db_folder}
  end

  def init(db_folder) do
    {:ok, db_folder}
  end

  defp file_name(db_foler, key), do: "#{db_foler}/#{key}"

  defp via_tuple(worker_number) do
    {:via, Todo.ProcessRegistry, {:database_worker, worker_number}}
  end
end
