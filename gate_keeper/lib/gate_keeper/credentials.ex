defmodule GateKeeper.Credentials do
  import Plug.Conn
  require Logger

  def init(opts), do: opts

  def call(%Plug.Conn{params: params} = conn, _opts) do
    username = Map.get(params, "username", nil)
    password = Map.get(params, "password", nil)

    conn
    |> assign(:username, username)
    |> assign(:password, password)
  end
end
