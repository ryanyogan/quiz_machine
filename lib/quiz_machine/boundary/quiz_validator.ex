defmodule QuizMachine.Boundary.QuizValidator do
  alias QuizMachine.Boundary.Validator

  def errors(fields) when is_map(fields) do
    []
    |> Validator.require(fields, :title, &validate_title/1)
    |> Validator.optional(fields, :steps_to_mastery, &validate_mastery/1)
  end

  def errors(_fields), do: [{nil, "A map of fields is required"}]

  defp validate_title(title) when is_binary(title) do
    Validator.check(String.match?(title, ~r{\S}), {:error, "can't be blank"})
  end

  defp validate_title(_title), do: {:error, "must be a string"}

  defp validate_mastery(steps_to_mastery) when is_integer(steps_to_mastery) do
    Validator.check(steps_to_mastery >= 1, {:error, "must be greater than zero"})
  end

  defp validate_mastery(_steps_to_mastery), do: {:error, "must be an integer"}
end
