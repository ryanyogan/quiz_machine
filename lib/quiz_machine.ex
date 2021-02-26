defmodule QuizMachine do
  @moduledoc false
  alias QuizMachine.Boundary.{
    QuizValidator,
    QuizSession,
    QuizManager,
    TemplateValidator
  }

  alias QuizMachine.Core.Quiz

  @spec build_quiz(any) :: any
  def build_quiz(fields) do
    with :ok <- QuizValidator.errors(fields),
         :ok <- GenServer.call(QuizManager, {:build_quiz, fields}),
         do: :ok,
         else: (error -> error)
  end

  @spec add_template(any, any) :: any
  def add_template(title, fields) do
    with :ok <- TemplateValidator.errors(fields),
         :ok <- GenServer.call(QuizManager, {:add_template, title, fields}),
         do: :ok,
         else: (error -> error)
  end

  @spec take_quiz(any, any) :: any
  def take_quiz(title, email) do
    with %Quiz{} = quiz <- QuizManager.lookup_quiz_by_title(title),
         {:ok, _} <- QuizSession.take_quiz(quiz, email) do
      {title, email}
    else
      error -> error
    end
  end

  @spec select_question({any, any}) :: any
  def select_question(session) do
    QuizSession.select_question(session)
  end

  @spec answer_question({any, any}, any) :: any
  def answer_question(session, answer) do
    QuizSession.answer_question(session, answer)
  end
end
