defmodule QuizMachine.Core.Question do
  @moduledoc """
  `Core.Question` is an immutable, constant instantiation of a `Core.Template`
  that defines the data for a particular `Core.Quiz`.
  """
  defstruct ~w[asked substitutions template]a
end
