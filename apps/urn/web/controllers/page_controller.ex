defmodule Urn.PageController do
  use Urn.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
