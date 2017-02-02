defmodule GateKeeper.Logger do
  require Logger
  def init(opts), do: opts
  def call(conn, _) do
    start = System.monotonic_time()

    conn
    |> log_incoming()
    |> setup_outgoing_hook(start)
  end

  defp log_incoming(conn) do
    username = conn.assigns[:username] || "nil"
    password = conn.assigns[:password] |> filter_password

   Logger.info fn ->
     [
       conn.method, ?\s, conn.request_path, ?\s,
       "username=[", username, "]", ?\s, "password=[", password, "]"
     ]
    end

    conn
  end

  defp setup_outgoing_hook(conn, start) do
    Plug.Conn.register_before_send(conn, fn conn ->
      Logger.info fn ->
        stop = System.monotonic_time()
        diff = System.convert_time_unit(stop - start, :native, :micro_seconds)

        ["Sent", ?\s, Integer.to_string(conn.status), " in ", formatted_diff(diff)]
      end
      conn
    end)
  end

  defp filter_password(nil), do: "nil"
  defp filter_password(_), do: "FILTERED"

  defp formatted_diff(diff) when diff > 1000, do: [diff |> div(1000) |> Integer.to_string, "ms"]
  defp formatted_diff(diff), do: [diff |> Integer.to_string, "µs"]
end
