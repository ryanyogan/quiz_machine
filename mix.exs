defmodule QuizMachine.MixProject do
  use Mix.Project

  def project do
    [
      app: :quiz_machine,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :eex],
      mod: {QuizMachine.Application, []}
    ]
  end

  defp deps do
    [
      {:excoveralls, "~> 0.14", only: :test},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end
end
