defmodule Todo.Server do
  use GenServer

  def start() do
    GenServer.start(Todo.Server, nil)
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

  def init(_) do
    {:ok, Todo.List.new([])}
  end

  def handle_cast({:put, key, value}, state) do
    {:noreply, Todo.List.add_entry(state, %{date: key, title: value})}
  end

  def handle_cast({:put, value}, state) do
    {:noreply, Todo.List.add_entry(state, value)}
  end

  def handle_call({:get, key}, _,  state) do
    {:reply, Todo.List.entries(state, key), state}
  end
end
