defmodule QuizMachine.MixProject do
  use Mix.Project

  def project do
    [
      app: :quiz_machine,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {QuizMachine.Application, []}
    ]
  end

  defp deps do
    []
  end
end
