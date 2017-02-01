defmodule Urn.Authentication.SessionTest do
  use Urn.ConnCase
  alias Urn.Authentication.Session
  import Plug.Conn

  @secret String.duplicate("abcdef0123456789", 8)
  @default_opts [
    store: :cookie,
    key: "foobar",
    encryption_salt: "encrypted cookie salt",
    signing_salt: "signing salt",
    log: false
  ]
  @signing_opts Plug.Session.init(Keyword.put(@default_opts, :encrypt, false))
  defp new_conn() do
    conn = build_conn()
    put_in(conn.secret_key_base, @secret)
    |> Plug.Session.call(@signing_opts)
    |> fetch_session
  end

  describe "authenticate" do
    test "it does not authenticate when no token is present" do
      status = new_conn() |> Session.authenticate()

      assert status == {:error, :forbidden}
    end

    test "it does not authenticate when the token is invalid" do
      status =
        new_conn()
        |> put_session(:token, "foo")
        |> Session.authenticate()

      assert status == {:error, :forbidden}
    end

    test "it authenticates when the token is valid" do
      conn = new_conn()
      username = "foo"
      token = Phoenix.Token.sign(Urn.Endpoint, "user", username)

      status =
        conn
        |> put_session(:token, token)
        |> Session.authenticate()

      assert status == {:ok, username, token}
    end
  end
end
