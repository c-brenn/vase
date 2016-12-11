defmodule Pot.PresenceTest do
  use ExUnit.Case

  describe "which_node?" do
    test "it identifies untracked presences" do
      assert Pot.Presence.which_node?("foo") == :none
    end

    test "it identifies local presences" do
      Pot.File.write("/foo")

      assert Pot.Presence.which_node?("/foo") == :local

      Pot.File.delete("/foo")
    end
  end
end
