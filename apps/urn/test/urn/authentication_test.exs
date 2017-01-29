defmodule Urn.AuthenticationTest do
  use Urn.ConnCase
  alias Urn.Authentication
  import Plug.Conn

  describe "call" do
    test "it does not authenticate when no header is present" do
      conn = build_conn() |> authenticate

      assert conn.status == 403
    end

    test "it does not authenticate when the token is invalid" do
      conn =
        build_conn()
        |> put_req_header("authentication", "foo")
        |> authenticate()

      assert conn.status == 403
    end

    test "it authenticates when the token is valid" do
      conn =
        build_conn()
        |> put_req_header("authentication", "secret")
        |> authenticate()

      assert conn.status != 403
    end
  end

  defp authenticate(conn) do
    Authentication.call(conn, [])
  end
end
