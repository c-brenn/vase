defmodule GateKeeper.Authentication do
  import Plug.Conn
  import Ecto.Query
  alias GateKeeper.{User, Repo}

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

  def authenticate(conn, username, password) when is_binary(username) do
    user = User |> where(username: ^username) |> Repo.one
    authenticate(conn, user, password)
  end

  def authenticate(conn, %User{} = user, password) do
    if User.authenticate(user, password) do
      conn
      |> send_resp(:ok, "")
    else
      conn
      |> send_resp(:forbidden, "")
    end
  end
end
