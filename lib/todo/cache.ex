defmodule Todo.Cache do
  use GenServer

  def init(_) do
    {:ok, Map.new}
  end

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def server_process(cache_pid, todo_list_name) do
    GenServer.call(cache_pid, {:server_process, todo_list_name})
  end

  def handle_call({:server_process, todo_list_name}, _, todo_servers) do
    case Map.get(todo_servers, todo_list_name) do
      nil ->
        {:ok, new_server} = Todo.Server.start

        {
          :reply,
          new_server,
          Map.put(todo_servers, todo_list_name, new_server)
        }
      todo_server ->
        {:reply, todo_server, todo_servers}
    end

  end
end
