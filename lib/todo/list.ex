defmodule Todo.List do
  defstruct auto_id: 1, entries: Map.new()

  def init(_) do
    {:ok, %Todo.List{}}
  end

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %Todo.List{},
      fn entry, todo_list_acc -> add_entry(todo_list_acc, entry) end
    )
  end

  def add_entry(
    %{entries: entries, auto_id: auto_id} = todo_list,
    %{date: _date, title: _title} = entry
  ) do
    entry =
      Map.put(entry, :id, auto_id)

    new_entries = Map.put(entries, auto_id, entry)

    %Todo.List{
      todo_list |
      entries: new_entries,
      auto_id: auto_id + 1
    }
  end

  def add_entry(
    %{entries: entries, auto_id: auto_id} = todo_list,
    entry
  ) when is_binary(entry) do
    entry =
      %{date: Date.utc_today(), id: auto_id, title: entry}

    new_entries = Map.put(entries, auto_id, entry)

    %Todo.List{
      todo_list |
      entries: new_entries,
      auto_id: auto_id + 1
    }
  end

  def update_entry(
    %Todo.List{entries: entries} =  todo_list,
    entry_id,
    updater_fun
  ) do
    case Map.get(todo_list, entry_id) do
      nil -> todo_list

      old_entry ->
        old_entry_id = old_entry.id
        new_entry = %{id: ^old_entry_id} =  updater_fun.(old_entry)
        new_entries = Map.put(entries, new_entry.id, new_entry)
        %Todo.List{todo_list | entries: new_entries}

    end
  end

  def entries(%Todo.List{entries: entries}, date) do
    entries
    |> Stream.filter(fn {_, entry} ->
        date == entry.date
      end)
    |> Enum.map(fn {_, entry} -> entry.title end)
  end

  def delete_entry(
    %Todo.List{entries: entries} = todo_list,
    entry_id
  ) do
    new_entries =
      Map.delete(entries, entry_id)

    %Todo.List{todo_list | entries: new_entries}
  end

end
