defmodule Pot do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Phoenix.PubSub.PG2, [Pot.PubSub, []]),
      supervisor(Pot.Presence, []),
      supervisor(Pot.File.Supervisor, []),
      supervisor(Registry, [:unique, Pot.File.Registry]),
      worker(Pot.File.Remote, []),
      worker(Pot.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: Pot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
