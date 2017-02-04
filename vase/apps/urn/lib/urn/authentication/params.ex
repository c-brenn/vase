defmodule Urn.Authentication.Params do
  import Plug.Conn
  alias Urn.Authentication.Token

  def init(opts), do: opts

  def call(conn, _opts) do
    case authenticate(conn) do
      {:ok, _username, _token} ->
        conn
      {:error, :forbidden} ->
        conn
        |> send_resp(:forbidden, "")
        |> halt()
    end
  end

  def authenticate(%Plug.Conn{params: %{"token" => token}} = conn) do
    Token.authenticate(token)
  end
  def authenticate(_), do: {:error, :forbidden}
end
