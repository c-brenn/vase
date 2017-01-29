defmodule Urn.Authentication do
  import Plug.Conn

  @secret "secret"

  def init(opts), do: opts

  def call(conn, _opts) do
    case authenticate(conn) do
      :ok -> conn
      :error ->
        conn
        |> put_status(:forbidden)
        |> halt()
    end
  end

  defp authenticate(%Plug.Conn{} = conn) do
    case get_req_header(conn, "authentication") do
      [@secret] -> :ok
      _         -> :error
    end
  end
end
