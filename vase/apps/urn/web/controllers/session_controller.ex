defmodule Urn.SessionController do
  use Urn.Web, :controller
  alias Urn.Authentication.Credentials

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => session_params}) do
    username = session_params["username"]
    password = session_params["password"]

    case Credentials.authenticate(username, password) do
      {:ok, ^username} ->
        token = Phoenix.Token.sign(conn, "user", username)
        conn
        |> put_session(:token, token)
        |> redirect(to: "/")
      {:error, :forbidden} ->
        conn
        |> put_flash(:info, "Incorrect username or password")
        |> render("new.html")
    end
  end
end
