defmodule QuizMachine.Core.Template do
  @moduledoc """
  `Core.Template` defines the base construct of a quiz, the following
  best encapsulates the features of this module.

  * Represent a grouping of questions on a quiz.
  * Generate questions with a compatible template and functions.
  * Check the response of a single question in the template.

  "A template generates questions."
  """
  defstruct ~w[name category instructions raw compiled generators checker]a

  def new(template_fields) do
    raw = Keyword.fetch!(template_fields, :raw)

    struct!(
      __MODULE__,
      Keyword.put(template_fields, :compiled, EEx.compile_string(raw))
    )
  end
end
