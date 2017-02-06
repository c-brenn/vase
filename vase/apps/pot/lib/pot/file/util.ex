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
        hash = hash(file)
        Pot.File.Local.replicate(path, file, hash)
        Pot.File.Remote.delete(path)
        Pot.File.Remote.replicate(path, file, hash)
        :ok
    end
  end

  def read(path) do
    case which_node?(path) do
      :local ->
        probabilistic_read_repair(path)
        Pot.File.Local.read(path)
      :none ->
        {:error, :no_such_file}
      {:remote, remote_node} ->
        {:error, :remote_file, remote_node}
    end
  end

  def delete(path) do
    Pot.File.Local.delete(path)
    Pot.File.Remote.delete(path)
  end

  def which_node?(path) do
    Pot.Presence.which_node?(path)
  end

  defp probabilistic_read_repair(path) do
    path
    |> probabilistic_read_repair(:rand.uniform())
  end

  defp probabilistic_read_repair(_, n) when n > 0.1, do: :ok
  defp probabilistic_read_repair(path, _) do
    Task.start(fn ->
      minority = Pot.Presence.find_minority(path)
      Pot.File.Remote.delete(path, minority)
    end)
  end
end
