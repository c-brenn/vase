defmodule Urn.Authentication.Session do
  import Plug.Conn
  alias Urn.Authentication.Token

  def authenticate(conn) do
    token  = get_session(conn, :token)
    Token.authenticate(token)
  end
end
