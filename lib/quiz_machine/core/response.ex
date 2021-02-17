defmodule QuizMachine.Core.Response do
  @moduledoc """
  `Core.Response` defines a response to an asked `Core.Question`.
  A `Response` contains the quiz, template, and individual meta-data.
  """

  defstruct ~w[quiz_title template_name to email answer correct_answer timestamp]a
end
