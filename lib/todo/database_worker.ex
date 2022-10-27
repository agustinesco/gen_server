defmodule Todo.DatabaseWorker do
  use GenServer

  def start_link(db_folder) do
    GenServer.start_link(__MODULE__, db_folder)
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
end
