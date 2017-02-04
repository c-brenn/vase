defmodule Pot.File.Util do
  def hash(file) do
    File.stream!(file, [], 2048)
    |> Enum.reduce(:crypto.hash_init(:md5), fn (line, acc) ->
      :crypto.hash_update(acc, line)
    end)
    |> :crypto.hash_final
  end

  def write(path, file) do
    case which_node?(path) do
      {:remote, remote_node} ->
        {:error, :remote_file, remote_node}
      :none ->
        hash = hash(file)
        Pot.File.Local.replicate(path, file, hash)
        Pot.File.Remote.replicate(path, file, hash)
        :ok
      :local ->
        # overwrite file contents
        hash = hash(file)
        delete(path)
        Pot.File.Local.replicate(path, file, hash)
        Pot.File.Remote.replicate(path, file, hash)
        :ok
    end
  end

  def delete(path) do
    Pot.File.Local.delete(path)
    Pot.File.Remote.delete(path)
  end

  def which_node?(path) do
    Pot.Presence.which_node?(path)
  end
end
