defmodule Urn.FileController do
  use Urn.Web, :controller

  def create(conn, %{"path" => path, "upload" => upload}) do
    full_path = Path.join([path, upload.filename])
    case Pot.File.write(full_path) do
      {:write_on_remote, node} ->
        node
      {:ok, _} -> :ok
    end

    conn
    |> redirect(to: "/#" <> path)
  end
end
