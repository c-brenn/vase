defmodule GateKeeper.AuthenticationTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias GateKeeper.Authentication

  @opts Authentication.init([])
end
