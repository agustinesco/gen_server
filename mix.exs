defmodule GenServers.MixProject do
  alias Todo.Application
  use Mix.Project

  def project do
    [
      app: :todo_app,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :gproc],
      mod: {Application, []},
      env: [
        port: 5454
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:meck, "~> 0.8.2", only: :test},
      {:gproc, "~> 0.9.0"},
      {:cowboy, "2.9.0"},
      {:plug, "1.14.0"},
      {:httpoison, "0.4.3", only: :test},
      {:plug_cowboy, "~> 2.6"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
