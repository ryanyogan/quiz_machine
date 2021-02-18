defmodule QuizMachine.Core.Response do
  @moduledoc """
  `Core.Response` defines a response to an asked `Core.Question`.
  A `Response` contains the quiz, template, and individual meta-data.
  """

  defstruct ~w[quiz_title template_name to email answer correct_answer timestamp]a

  def new(quiz, email, answer) do
    question = quiz.current_question
    template = question.template

    %__MODULE__{
      quiz_title: quiz.title,
      template_name: template.name,
      to: question.asked,
      email: email,
      answer: answer,
      correct_answer: template.checker.(question.substitutions, answer),
      timestamp: DateTime.utc_now()
    }
  end
end
