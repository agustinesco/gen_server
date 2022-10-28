defmodule Todo.Cache do
  use GenServer

  def init(_) do
    IO.inspect("PERMISO QUE VOY ARDIENDO")
    {:ok, Map.new}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: :cache)
  end

  def server_process(todo_list_name) do
    GenServer.call(:cache, {:server_process, todo_list_name})
  end

  def handle_call({:morir}, _, todo_servers) do
    exit("ME VOY PERRAS")

    {:noreply, todo_servers}
  end


  def handle_call({:server_process, todo_list_name}, _, todo_servers) do
    case Map.get(todo_servers, todo_list_name) do
      nil ->
        {:ok, new_server} = Todo.Server.start_link(todo_list_name)

        {
          :reply,
          new_server,
          Map.put(todo_servers, todo_list_name, new_server)
        }
      todo_server ->
        {:reply, todo_server, todo_servers}
    end
  end

  def handle_call({:saludar}, _, todo_servers) do

    {:reply, "hola!", todo_servers}
  end
end
