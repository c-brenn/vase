defmodule Urn.Node do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    host =
      Application.get_env(:urn, Urn.Endpoint)
      |> get_in([:url, :host])

    port =
      Application.get_env(:urn, Urn.Endpoint)
        |> get_in([:http, :port])

    meta = %{host: host, port: port}
    node = Node.self

    Pot.Presence.track(self(), {:node, node}, node, meta)

    {:ok, {host, port}}
  end

  def http_info(node_name) do
    [{^node_name, %{host: host, port: port}}] =
      Phoenix.Tracker.list(Pot.Presence, {:node, node_name})

    %{host: host, port: "#{port}"}
  end
end
