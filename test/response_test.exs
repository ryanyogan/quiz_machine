defmodule ResponseTest do
  use ExUnit.Case
  use QuizBuilders

  defp quiz do
    fields = template_fields(generators: %{left: [1], right: [2]})

    build_quiz()
    |> Quiz.add_template(fields)
    |> Quiz.select_question()
  end

  defp response(answer) do
    Response.new(quiz(), "ryan@example.com", answer)
  end

  defp right(context) do
    {:ok, Map.put(context, :right, response("3"))}
  end

  defp wrong(context) do
    {:ok, Map.put(context, :wrong, response("2"))}
  end

  describe "a right response and a wrong response" do
    setup [:right, :wrong]

    test "building responses checks answer", %{right: right, wrong: wrong} do
      assert right.correct_answer
      refute wrong.correct_answer
    end

    test "a timestamp is added at build time", %{right: response} do
      assert %DateTime{} = response.timestamp
      assert response.timestamp < DateTime.utc_now()
    end
  end
end
