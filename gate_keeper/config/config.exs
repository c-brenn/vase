use Mix.Config

config :gate_keeper, :ecto_repos, [GateKeeper.Repo]

config :gate_keeper, GateKeeper.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "gate_keeper",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
