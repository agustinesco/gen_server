defmodule Todo.Server do
  use GenServer

  def start_link(name) do
    GenServer.start_link(Todo.Server, name)
  end

  def put(pid, key, value) do
    GenServer.cast(pid, {:put, key, value})
  end

  def put(pid, value) do
    GenServer.cast(pid, {:put, value})
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  def init(name) do
    send(self(), :real_init)
    {:ok, {name, nil}}
  end

  def handle_info(:real_init, {name, _state}) do
    IO.puts("Iniciando la lista para #{name}")
    {:noreply, {name, Todo.Database.get(name) || Todo.List.new()}}
  end

  def handle_cast({:put, key, value}, {name, state}) do
    new_state = Todo.List.add_entry(state, %{date: key, title: value})
    Todo.Database.store(name, new_state)
    {:noreply, {name, new_state}}
  end

  def handle_cast({:put, value}, {name, state}) do
    new_state = Todo.List.add_entry(state, value)
    Todo.Database.store(name, new_state)
    {:noreply, {name, new_state}}
  end

  def handle_call({:get, key}, _,  {_name, todo_list} = state) do
    result = Todo.List.entries(todo_list, key)
    {:reply, result, state}
  end
end
