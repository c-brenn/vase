defmodule Urn.FileController do
  use Urn.Web, :controller

  def create(conn, %{"path" => path, "upload" => upload}) do
    case Pot.File.write(path, upload.path) do
      {:error, :remote_file, node} ->
        conn
        |> put_status(422)
        |> json(%{error: "wrong node", node: node})
      :ok ->
        conn
        |> text("gr8")
    end
  end

  def replicate(conn,  %{"path" => path, "hash" => hash}) do
    Pot.File.Local.delete(path)
    Pot.File.Local.replicate(path, nil, hash)
    conn |> text("success")
  end

  def whereis(conn, %{"file" => path}) do
    node =
      case Pot.File.which_node?(path) do
        {:remote, remote_node} ->
          remote_node
        _ ->
          Node.self
      end

    conn
    |> json(Urn.Node.http_info(node))
  end

  def delete(conn, %{"file" => path}) do
    Pot.File.delete(path)
    conn
    |> put_status(200)
    |> text("gr8")
  end
end
