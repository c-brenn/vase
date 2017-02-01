defmodule Urn.Authentication.Session do
  import Plug.Conn

  @max_age 1209600

  def authenticate(conn) do
    token  = get_session(conn, :token)
    status = Phoenix.Token.verify(
      Urn.Endpoint,
      "user",
      token,
      max_age: @max_age
    )

    case status do
      {:ok, username} -> {:ok, username, token}
      {:error, _} -> {:error, :forbidden}
    end
  end
end
