defmodule QuizMachine.Boundary.QuizSession do
  alias QuizMachine.Core.{Quiz, Response}
  use GenServer

  def select_question(name) do
    GenServer.call(via(name), :select_question)
  end

  def answer_question(name, answer) do
    GenServer.call(via(name), {:answer_question, answer})
  end

  def child_spec({quiz, email}) do
    %{
      id: {__MODULE__, {quiz.title, email}},
      start: {__MODULE__, :start_link, [{quiz, email}]},
      restart: :temporary
    }
  end

  def start_link({quiz, email}) do
    GenServer.start_link(
      __MODULE__,
      {quiz, email},
      name: via({quiz.title, email})
    )
  end

  def take_quiz(quiz, email) do
    DynamicSupervisor.start_child(
      QuizMachine.Supervisor.QuizSession,
      {__MODULE__, {quiz, email}}
    )
  end

  def active_sessions_for(quiz_title) do
    QuizMachine.Supervisor.QuizSession
    |> DynamicSupervisor.which_children()
    |> Enum.filter(&child_pid?/1)
    |> Enum.flat_map(&active_sessions(&1, quiz_title))
  end

  def end_sessions(names) do
    Enum.each(names, fn name -> GenServer.stop(via(name)) end)
  end

  defp child_pid?({:undefined, pid, :worker, [__MODULE__]}) when is_pid(pid) do
    true
  end

  defp child_pid?(_child), do: false

  defp active_sessions({:undefined, pid, :worker, [__MODULE__]}, title) do
    QuizMachine.Registry.QuizSession
    |> Registry.keys(pid)
    |> Enum.filter(fn {quiz_title, _email} ->
      quiz_title == title
    end)
  end

  @impl true
  def init({quiz, email}) do
    {:ok, {quiz, email}}
  end

  @impl true
  def handle_call(:select_question, _from, {quiz, email}) do
    quiz = Quiz.select_question(quiz)
    {:reply, quiz.current_question.asked, {quiz, email}}
  end

  @impl true
  def handle_call({:answer_question, answer}, _from, {quiz, email}) do
    quiz
    |> Quiz.answer_question(Response.new(quiz, email, answer))
    |> Quiz.select_question()
    |> maybe_finish(email)
  end

  defp maybe_finish(nil, _email), do: {:stop, :normal, :finished, nil}

  defp maybe_finish(quiz, email) do
    {
      :reply,
      {quiz.current_question.asked, quiz.last_response.correct_answer},
      {quiz, email}
    }
  end

  def via({_title, _email} = name) do
    {
      :via,
      Registry,
      {QuizMachine.Registry.QuizSession, name}
    }
  end
end
