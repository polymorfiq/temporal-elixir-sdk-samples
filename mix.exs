defmodule TemporalSamples.MixProject do
  use Mix.Project

  def project do
    [
      app: :temporal_samples,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:temporal, "~> 0.0.1",
       github: "polymorfiq/temporal-elixir-sdk", sha: "9487f6756df91d1a1c6ac25d556a52e3bdd6fe9f"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
