defmodule QuizMachine.Core.Quiz do
  @moduledoc """
  `Core.Quiz` maintains a reference to the state of the current `Quiz` as well
  as any current game-state usch as used templates, records (correct answers), and
  mastered `Question`-s.
  """
  defstruct title: nil,
            steps_to_mastery: 3,
            templates: %{},
            used: [],
            current_question: nil,
            last_response: nil,
            record: %{},
            mastered: []
end
