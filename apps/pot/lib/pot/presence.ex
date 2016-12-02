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
      for {_, {joins, leaves}} <- diff do
        Urn.FileEventsChannel.broadcast_diff(group(joins), group(leaves))
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

  defp group(presences) do
    presences
    |> Enum.reverse()
    |> Enum.reduce(%{}, fn {key, meta}, acc ->
      Map.update(acc, to_string(key), %{metas: [meta]}, fn %{metas: metas} ->
        %{metas: [meta | metas]}
      end)
    end)
  end
end
