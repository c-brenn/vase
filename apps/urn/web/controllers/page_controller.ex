defmodule Urn.PageController do
  use Urn.Web, :controller
  alias Urn.Authentication.Session

  def index(conn, _params) do
    case Session.authenticate(conn) do
      {:ok, _username, token} ->
        render conn, "index.html", token: token
      {:error, :forbidden} ->
        redirect conn, to: "/login"
    end
  end
end
