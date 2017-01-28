defmodule Pot.File.Local do
  def replicate(path, hash) do
    {:ok, pid} = Pot.File.Supervisor.track_file(path)
    register_presences(pid, path, hash)
  end

  def delete(path) do
    Registry.dispatch(Pot.File.Registry, path, fn files ->
      for { pid, _ } <- files do
        Supervisor.terminate_child(Pot.File.Supervisor, pid)
      end
    end)
  end

  @doc """
  Phoenix.Presence is used to track files across the cluster. There is no real
  notion of a directory. Writing a file to given path creates the directories
  in the path. This is to avoid having directories living on separate servers
  to their contents (even worse when nested) - causing deltions/moves to
  require massive coordination across the cluster. Each `File` process is
  registered by name, then it is tracked in `Presence`. It is tracked against
  each directory in the path, so that directories disappear when empty (it also
  greatly simplifies `ls` et. al.)
  """
  def register_presences(pid, path, hash) do
    node = Phoenix.PubSub.node_name(Pot.PubSub)

    # we store the node name so files can be easily located across the cluster
    Pot.Presence.track(pid, {:file, path}, node, %{hash: hash})

    dir = Path.dirname(path)
    base = Path.basename(path)
    register_presences(pid, dir, base, :file)
  end
  def register_presences(_, "", _, _), do: :ok
  def register_presences(pid, "/", base, type) do
    Pot.Presence.track(pid, "/", {type, base}, %{})
  end
  def register_presences(pid, dir, base, type) do
    Pot.Presence.track(pid, dir, {type, base}, %{})

    new_dir = Path.dirname(dir)
    new_base = Path.basename(dir)
    register_presences(pid, new_dir, new_base, :directory)
  end
end
