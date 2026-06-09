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
       github: "polymorfiq/temporal-elixir-sdk", ref: "dbf241b7facb05bf38587ea2b0f13504079fdb4a"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
