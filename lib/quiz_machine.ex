defmodule QuizMachine do
  @moduledoc false
  alias QuizMachine.Boundary.{
    QuizValidator,
    QuizSession,
    QuizManager,
    TemplateValidator
  }

  alias QuizMachine.Core.Quiz

  @spec start_quiz_manager :: :ignore | {:error, any} | {:ok, pid}
  def start_quiz_manager do
    GenServer.start_link(QuizManager, %{}, name: QuizManager)
  end

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
         {:ok, session} <- GenServer.start_link(QuizSession, {quiz, email}) do
      session
    else
      error -> error
    end
  end

  @spec select_question(atom | pid | {atom, any} | {:via, atom, any}) :: any
  def select_question(session) do
    GenServer.call(session, :select_question)
  end

  @spec answer_question(atom | pid | {atom, any} | {:via, atom, any}, any) :: any
  def answer_question(session, answer) do
    GenServer.call(session, {:answer_question, answer})
  end
end
