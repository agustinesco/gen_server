defmodule CvsImporter do
  def read_file() do
    File.read!("lib/todos.cvs")
    |> String.split("\r\n")
    |> Enum.reduce(
      [],
      fn entry, acc -> [String.split(entry, ",") | acc] end
    )
    |> Enum.reduce(
      %Todo.List{},
      fn entry, todo_acc -> Todo.List.add_entry(todo_acc, %{date: Date.from_iso8601!(Enum.at(entry,0)), title: Enum.at(entry,1)}) end
    )
  end
end
