defmodule Urn.DirectoriesChannel do
  use Urn.Web, :channel
  alias Phoenix.{
    Socket.Broadcast,
    PubSub
  }

  def join("directories:" <> dir, _, socket) do
    send self(), {:after_join, dir}
    {:ok, socket}
  end

  def handle_info({:after_join, dir}, socket) do
    push socket, "ls", Pot.Dir.ls(dir)
    {:noreply, socket}
  end

  def broadcast_diff(directory, additions, deletions) do
    topic = "directories:" <> directory
    msg = %Broadcast{topic: topic, event: "presence_diff", payload: %{
      additions: additions,
      deletions: deletions
    }}

    PubSub.direct_broadcast!(
      PubSub.node_name(Urn.PubSub),
      Urn.PubSub,
      topic,
      msg
    )
  end
end
