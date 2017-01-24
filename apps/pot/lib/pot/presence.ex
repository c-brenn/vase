defmodule Pot.Presence do
  @type presences :: %{ String.t => %{metas: [map()]}}
  @type presence :: %{key: String.t, meta: map()}
  @type topic :: String.t

  @callback start_link(Keyword.t) :: {:ok, pid()} | {:error, reason :: term()} :: :ignore
  @callback init(Keyword.t) :: {:ok, pid()} | {:error, reason :: term}
  @callback track(pid, topic, key :: String.t, meta :: map()) :: {:ok, binary()} | {:error, reason :: term()}
  @callback untrack(pid, topic, key :: String.t) :: :ok
  @callback update(pid, topic, key :: String.t, meta :: map() | (map() -> map())) :: {:ok, binary()} | {:error, reason :: term()}
  @callback fetch(topic, presences) :: presences
  @callback list(topic) :: presences
  @callback handle_diff(%{topic => {joins :: presences, leaves :: presences}}, state :: term) :: {:ok, state :: term}

  @otp_app :pot
  @pubsub_server Pot.PubSub
  @task_supervisor Module.concat(__MODULE__, TaskSupervisor)

  def init(opts) do
    server = Keyword.fetch!(opts, :pubsub_server)
    {:ok, %{pubsub_server: server,
      node_name: Phoenix.PubSub.node_name(server),
      task_sup: @task_supervisor}}
  end

  def track(pid, topic, key, meta) do
    Phoenix.Tracker.track(__MODULE__, pid, topic, key, meta)
  end

  def untrack(pid, topic, key) do
    Phoenix.Tracker.untrack(__MODULE__, pid, topic, key)
  end

  def update(pid, topic, key, meta) do
    Phoenix.Tracker.update(__MODULE__, pid, topic, key, meta)
  end

  def fetch(_topic, presences), do: presences

  def handle_diff(diff, state) do
    Task.Supervisor.start_child(@task_supervisor, fn ->
      for {directory, {additions, potential_deletions}} <- diff, not is_tuple(directory) do

        still_present = list(directory)
        potential_deletions = group(potential_deletions)

        deletions = %{
          directories: MapSet.difference(
            potential_deletions.directories,
            still_present.directories
          ),
          files: MapSet.difference(
            potential_deletions.files,
            still_present.files
          ),

        }

        Urn.DirectoriesChannel.broadcast_diff(
          directory,
          group(additions),
          deletions
        )
      end
    end)
    {:ok, state}
  end

  def start_link do
    import Supervisor.Spec

    opts =
      Keyword.new
      |> Keyword.merge(Application.get_env(@otp_app, __MODULE__) || [])
      |> Keyword.put(:name, __MODULE__)
      |> Keyword.put(:pubsub_server, @pubsub_server)

    children = [
      supervisor(Task.Supervisor, [[name: @task_supervisor]]),
      worker(Phoenix.Tracker, [__MODULE__, opts, opts])
    ]
      Supervisor.start_link(children, strategy: :one_for_one)
  end

  def list(topic) do
    grouped =
      __MODULE__
      |> Phoenix.Tracker.list(topic)
      |> group()

    fetch(topic, grouped)
  end

  def which_node?(path) do
    local_node = Phoenix.PubSub.node_name(Pot.PubSub)
    case Phoenix.Tracker.list(__MODULE__, {:file, path}) do
      [] -> :none
      [{^local_node, _}|_] -> :local
      [{remote_node, _}|_] -> {:remote, remote_node}
    end
  end

  defp group(presences) do
    presences
    |> Enum.reduce(%{files: MapSet.new, directories: MapSet.new}, fn {{type, path}, _}, acc ->
      case type do
        :file ->
          %{acc| files: MapSet.put(acc.files, path)}
        :directory ->
          %{acc| directories: MapSet.put(acc.directories, path)}
      end
    end)
  end
end
