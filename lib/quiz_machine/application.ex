defmodule QuizMachine.Application do
  @moduledoc false
  alias QuizMachine.Boundary.QuizManager
  use Application

  @impl true
  def start(_type, _args) do
    IO.puts("Starting QuizMachine")

    children = [
      {QuizManager, [name: QuizManager]},
      {Registry, [name: QuizMachine.Registry.QuizSession, keys: :unique]},
      {DynamicSupervisor, [name: QuizMachine.Supervisor.QuizSession, strategy: :one_for_one]}
    ]

    opts = [strategy: :one_for_one, name: QuizMachine.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
