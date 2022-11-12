defmodule Todo.Application do
  use Application

  def start(_, _ ) do

    childrens = [
      %{
        id: Todo.Supervisor,
        start: {Todo.Supervisor, :start_link, [nil]},
        type: :supervisor
      }
    ]

    opts = [strategy: :one_for_one, name: :application_supervisor]
    Supervisor.start_link(childrens, opts)
  end
end
