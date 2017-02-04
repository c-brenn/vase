defmodule Urn.FileController do
  use Urn.Web, :controller

  def create(conn, %{"path" => path, "upload" => upload}) do
    case Pot.File.write(path, upload.path) do
      {:error, :remote_file, node} ->
        conn
        |> redirect(external: remote_url(conn, node))
      :ok ->
        conn
        |> send_resp(200, "")
    end
  end

  def read(conn, %{"file" => path}) do
    case Pot.File.read(path) do
      {:ok, contents} ->
        file_name = Path.basename(path)
        conn
        |> put_resp_content_type("application/octet-stream")
        |> put_resp_header("content-disposition", "attachment; filename=\"#{file_name}\"")
        |> send_resp(200, contents)
      {:error, :remote_file, node} ->
        conn
        |> redirect(external: remote_url(conn, node))
      _ ->
        conn
        |> send_resp(404, "file not found")
    end
  end

  def replicate(conn,  %{"path" => path,
                         "hash" => hash,
                         "file" => file}) do
    Pot.File.Local.delete(path)
    Pot.File.Local.replicate(path, file, hash)
    conn |> text("success")
  end

  def delete(conn, %{"file" => path}) do
    case Pot.File.which_node?(path) do
      :local ->
        Pot.File.delete(path)
        conn
        |> send_resp(200, "")
      {:remote, node} ->
        conn
        |> redirect(external: remote_url(conn, node))
    end
  end

  defp remote_url(conn, node) do
    %{host: host, port: port} = Urn.Node.http_info(node)
    "http://#{host}:#{port}" <> conn.request_path <> "?" <> conn.query_string
  end
end
