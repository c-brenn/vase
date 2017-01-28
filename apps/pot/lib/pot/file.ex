defmodule Pot.File do
  use GenServer

  def start_link(path) do
    GenServer.start_link(__MODULE__, path)
  end

  def init(path) do
    Registry.register(Pot.File.Registry, path, nil)
    {:ok, path}
  end

  def write(path, temp_file) do
    case which_node?(path) do
      {:remote, remote_node} ->
        {:error, :remote_file, remote_node}
      :none ->
        hash = hash(temp_file)
        Pot.File.Local.replicate(path, hash)
        Pot.File.Remote.replicate(path, hash)
        :ok
      :local ->
        # overwrite file contents
        hash = hash(temp_file)
        delete(path)
        Pot.File.Local.replicate(path, hash)
        Pot.File.Remote.replicate(path, hash)
        :ok
    end
  end

  def which_node?(path) do
    Pot.Presence.which_node?(path)
  end

  def delete(path) do
    Pot.File.Local.delete(path)
    Pot.File.Remote.delete(path)
  end

  def hash(temp_file) do
    File.stream!(temp_file, [], 2048)
    |> Enum.reduce(:crypto.hash_init(:md5), fn (line, acc) ->
      :crypto.hash_update(acc, line)
    end)
    |> :crypto.hash_final
  end
end
