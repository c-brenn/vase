defmodule GateKeeper do
  use Application


  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(GateKeeper.Router, []),
      worker(GateKeeper.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: GateKeeper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
