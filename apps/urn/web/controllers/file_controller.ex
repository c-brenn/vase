defmodule Urn.FileController do
  use Urn.Web, :controller

  def create(conn, %{"path" => path, "upload" => _upload}) do
    case Pot.File.write(path) do
      {:write_on_remote, node} ->
        conn
        |> put_status(422)
        |> json(%{error: "wrong node", node: node})
      {:ok, _} ->
        conn
        |> text("gr8")
    end
  end

  def whereis(conn, %{"file" => path}) do
    node =
      case Pot.File.which_node?(path) do
        {:remote, remote_node} ->
          remote_node
        _ ->
          Phoenix.PubSub.node_name(Pot.PubSub)
      end

    [port, host] =
      node
      |> Atom.to_string
      |> String.split("@")

    conn
    |> json(%{host: host, port: port})
  end

  def delete(conn, %{"file" => path}) do
    Pot.File.delete(path)
    conn
    |> put_status(200)
    |> text("gr8")
  end
end
