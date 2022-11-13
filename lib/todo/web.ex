defmodule Todo.Web do
  use Plug.Router

  plug :match
  plug :dispatch

  def start_server do
    case Application.get_env(:todo, :port) do
      nil -> raise("Puerto no establecido")
      port ->
        Plug.Adapters.Cowboy.http(__MODULE__, [], port: port)
    end
  end

  post "/add_entry" do
    conn
    |> Plug.Conn.fetch_query_params()
    |> add_entry()
    |> respond()
  end

  get "entries" do
    conn
    |> Plug.Conn.fetch_query_params()
    |> get_entries()
    |> respond()
  end

  defp get_entries(conn) do
    entries = conn.params["list"]
    |> Todo.Cache.server_process()
    |> Todo.Server.get(parse_date(conn.params["date"]))

    Plug.Conn.assign(conn, :response, entries)
  end

  defp add_entry(conn) do
    conn.params["list"]
    |> Todo.Cache.server_process()
    |> Todo.Server.put(
      parse_date(conn.params["date"]),
      conn.params["title"]
    )
    Plug.Conn.assign(conn, :response, "OK")
  end

  defp respond(conn) do
    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, conn.assigns[:response])
  end

  defp parse_date(date) do
    "#{String.slice(date, 0..3)}-#{String.slice(date, 3..4)}-#{String.slice(date, 5..6)}"
  end

end
