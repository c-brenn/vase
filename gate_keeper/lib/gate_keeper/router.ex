defmodule GateKeeper.Router do
  use Plug.Builder
  require Logger
  @port 8000

  plug Plug.Parsers, parsers: [:urlencoded, :json]
  plug GateKeeper.Credentials
  plug GateKeeper.Logger
  plug GateKeeper.Authentication

  def init(opts), do: opts

  def start_link(_) do
    {:ok, pid} = Plug.Adapters.Cowboy.http(__MODULE__, [], port: @port)
    Logger.info("Gatekeeper listening on port: #{@port}")
    {:ok, pid}
  end
end
