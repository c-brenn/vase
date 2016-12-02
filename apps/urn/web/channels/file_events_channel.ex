defmodule Urn.FileEventsChannel do
  use Urn.Web, :channel
  alias Pot.Presence
  alias Phoenix.Socket.Broadcast

  def join("file_events", _, socket) do
    send self(), :after_join
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list("files")
    {:noreply, socket}
  end

  def broadcast_diff(joins, leaves) do
    msg = %Broadcast{topic: "file_events", event: "presence_diff", payload: %{
      joins: joins,
      leaves: leaves
    }}
    Phoenix.PubSub.direct_broadcast!(Phoenix.PubSub.node_name(Urn.PubSub), Urn.PubSub, "file_events", msg)
  end
end
