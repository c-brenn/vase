defmodule Pot.File do
  use GenServer
  use Ecto.Schema
  alias Pot.Repo

  schema "files" do
    field :path, :string
    field :contents, :binary
    timestamps
  end

  def start_link(path, id) do
    GenServer.start_link(__MODULE__, {path, id})
  end

  def init({path, id}) do
    Registry.register(Pot.File.Registry, path, nil)
    {:ok, {path, id}}
  end

  def write(path, file) do
    Pot.File.Util.write(path, file)
  end

  def which_node?(path) do
    Pot.File.Util.which_node?(path)
  end

  def delete(path) do
    Pot.File.Util.delete(path)
  end

  def handle_cast(:delete, {path, id}) do
    %Pot.File{id: id}
    |> Repo.delete()

    {:stop, :normal, path}
  end

  def terminate(_, _), do: :ok
end
