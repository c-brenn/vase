defmodule GateKeeper.Mixfile do
  use Mix.Project

  def project do
    [app: :gate_keeper,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [
        :logger,
        :cowboy,
        :plug,
        :postgrex,
        :ecto
     ],
     mod: {GateKeeper, []}]
  end

  defp deps do
    [
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"},
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 2.1"}
    ]
  end
end
