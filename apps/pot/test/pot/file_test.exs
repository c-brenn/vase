defmodule Pot.FileTest do
  use ExUnit.Case

  test "it registers the file's presence" do
    Pot.File.write "/home/conor/.vimrc"

    assert Pot.Presence.list("/home/conor/.vimrc").files |> MapSet.to_list == [Phoenix.PubSub.node_name(Pot.PubSub)]

    Pot.File.delete "/home/conor/.vimrc"
  end
end
