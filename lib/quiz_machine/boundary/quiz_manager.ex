defmodule QuizMachine.Boundary.QuizManager do
  alias QuizMachine.Core.Quiz
  use GenServer

  @me __MODULE__

  def start_link(options \\ []) do
    GenServer.start_link(@me, %{}, options)
  end

  def build_quiz(manager \\ @me, quiz_fields) do
    GenServer.call(manager, {:build_quiz, quiz_fields})
  end

  def add_template(manager \\ @me, quiz_title, template_fields) do
    GenServer.call(manager, {:add_template, quiz_title, template_fields})
  end

  def lookup_quiz_by_title(manager \\ @me, quiz_title) do
    GenServer.call(manager, {:lookup_quiz_by_title, quiz_title})
  end

  def remove_quiz(manager \\ @me, quiz_title) do
    GenServer.call(manager, {:remove_quiz, quiz_title})
  end

  @impl true
  def init(quizzes) when is_map(quizzes) do
    {:ok, quizzes}
  end

  def init(_quizzes), do: {:error, "quizzes must be a map"}

  @impl true
  def handle_call({:build_quiz, quiz_fields}, _from, quizzes) do
    quiz = Quiz.new(quiz_fields)
    new_quizzes = Map.put(quizzes, quiz.title, quiz)
    {:reply, :ok, new_quizzes}
  end

  @impl true
  def handle_call(
        {:add_template, quiz_title, template_fields},
        _from,
        quizzes
      ) do
    new_quizzes =
      Map.update!(quizzes, quiz_title, fn quiz ->
        Quiz.add_template(quiz, template_fields)
      end)

    {:reply, :ok, new_quizzes}
  end

  @impl true
  def handle_call({:lookup_quiz_by_title, quiz_title}, _from, quizzes) do
    {:reply, quizzes[quiz_title], quizzes}
  end

  @impl true
  def handle_call({:remove_quiz, quiz_title}, _from, quizzes) do
    new_quizzes = Map.delete(quizzes, quiz_title)
    {:reply, :ok, new_quizzes}
  end
end
