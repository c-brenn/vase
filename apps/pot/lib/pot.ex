defmodule Pot do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Phoenix.PubSub.PG2, [Pot.PubSub, []]),
      supervisor(Pot.Presence, [])
    ]

    opts = [strategy: :one_for_one, name: Pot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
