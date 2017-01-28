defmodule Pot.File.Remote do
  use GenServer
  @name __MODULE__

  @moduledoc """
  Handles remote replicas of files. Each Node in the Cluster runs a
  `Pot.File.Remote` process. This GenServer listens for delete events
  from other nodes and deletes the files locally.
  """

  def start_link do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def replicate(path, hash) do
    replicas = choose_replicas
    for replica <- replicas do
      do_replicate(replica, path, hash)
    end
  end

  defp choose_replicas do
    num_replicas = Application.get_env(:pot, :replicas, 1)
    Enum.take_random(Node.list, num_replicas)
  end

  defp do_replicate(replica, path, hash) do
    Task.start(fn ->
      %{host: host, port: port} = Urn.Node.http_info(replica)
      uri = host <> ":" <> port <> "/api/files/replicate"

      HTTPoison.post(uri, {:form, [{:path, path}, {:hash, hash}]})
    end)
  end

  def delete(path) do
    GenServer.abcast(Node.list, Pot.File.Remote, {:delete, path})
  end

  def handle_cast({:delete, path}, s) do
    Pot.File.Local.delete(path)
    {:noreply, s}
  end
end
