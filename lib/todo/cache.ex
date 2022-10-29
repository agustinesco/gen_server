defmodule Todo.Cache do

  def server_process(todo_list_name) do
    case Todo.Server.whereis(todo_list_name) do
      :undefined ->
        {:ok, new_server} = Todo.ServerSupervisor.start_child(todo_list_name)

        new_server
      pid ->
        pid
    end
  end
end
