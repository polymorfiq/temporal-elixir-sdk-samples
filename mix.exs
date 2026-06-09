defmodule TemporalSamples.MixProject do
  use Mix.Project

  def project do
    [
      app: :temporal_samples,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      prune_code_paths: false,
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    temporal_lib =
      if System.get_env("LOCAL_TEMPORAL") == "1" do
        {:temporal, "~> 0.0.1", path: "../temporal"}
      else
        {:temporal, "~> 0.0.1",
         github: "polymorfiq/temporal-elixir-sdk", ref: "01d0e90de5ae6fb98a1e26575594a983abb3efbd"}
      end

    [
      temporal_lib,
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
