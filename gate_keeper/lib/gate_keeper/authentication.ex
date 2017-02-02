defmodule GateKeeper.Authentication do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    username = conn.assigns[:username]
    password = conn.assigns[:password]

    authenticate(conn, username, password)
  end

  def authenticate(conn, un, pw) when is_nil(un) or is_nil(pw) do
    conn
    |> send_resp(:forbidden, "")
  end

  def authenticate(conn, _username, password) do
    if password == "secret" do
      conn
      |> send_resp(:ok, "")
    else
      conn
      |> send_resp(:forbidden, "")
    end
  end
end
