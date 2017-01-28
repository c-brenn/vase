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
        {:write_on_remote, remote_node}
      :none ->
        {:ok, pid} = Pot.File.Supervisor.track_file(path)
        file_hash = hash(temp_file)
        register_presences(pid, path, file_hash)
        replicate_remotely(path, file_hash)
        {:ok, pid}
      :local ->
        # overwrite file contents
        # delete replicas
        # replicate again
    end
  end

  def replicate_remotely(path, hash) do
    num_replicas = Application.get_env(:pot, :replicas, 1)
    replicas = Enum.take_random(Node.list, num_replicas)

    for replica <- replicas do
      Task.start(fn ->
        %{host: host, port: port} = Urn.Node.http_info(replica)
        uri = host <> ":" <> port <> "/api/files/replicate"

        HTTPoison.post(uri, {:form, [{:path, path, hash: hash}]})
      end)
    end
  end

  def replicate_locally(path, hash) do
    delete(path)
    {:ok, pid} = Pot.File.Supervisor.track_file(path)
    register_presences(pid, path, hash)
  end

  def which_node?(path) do
    Pot.Presence.which_node?(path)
  end

  def delete(path) do
    Registry.dispatch(Pot.File.Registry, path, fn files ->
      for { pid, _ } <- files do
        Supervisor.terminate_child(Pot.File.Supervisor, pid)
      end
    end)
  end

  def hash(temp_file) do
    File.stream!(temp_file, [], 2048)
    |> Enum.reduce(:crypto.hash_init(:md5), fn (line, acc) ->
      :crypto.hash_update(acc, line)
    end)
    |> :crypto.hash_final
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
