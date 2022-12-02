defmodule RockPaperScissors do
  @points_for_a_win 6
  @points_for_a_draw 3
  @points_for_a_loss 0

  # The score for a single round is the score for the shape you selected
  # (1 for Rock, 2 for Paper, and 3 for Scissors)
  # plus the score for the outcome of the round
  # (0 if you lost, 3 if the round was a draw, and 6 if you won)
  def score(filepath, part \\ 1) do
    IO.puts File.read!(filepath)
      |> String.split("\n")
      |> Enum.map(fn round_result -> score_for_the_round(round_result, part) end)
      |> Enum.sum()
  end

  defp score_for_the_round("", _part), do: 0

  defp score_for_the_round(round_result, 1) do
    [opponent_move, your_move] = String.split(round_result, " ")
    move_score(your_move) + round_result_score(opponent_move, your_move)
  end

  defp score_for_the_round(round_result, 2) do
    [opponent_move, round_result] = String.split(round_result, " ")
    case round_result do
      "X" -> # lose
        losing_move(opponent_move)
        |> move_score()
        |> Kernel.+(@points_for_a_loss)
      "Y" -> # draw
        move_score(opponent_move) + @points_for_a_draw
      "Z" -> # win
        winning_move(opponent_move)
        |> move_score()
        |> Kernel.+(@points_for_a_win)
    end
  end

  defp losing_move("A"), do: "C"
  defp losing_move("B"), do: "A"
  defp losing_move("C"), do: "B"

  defp winning_move("A"), do: "B"
  defp winning_move("B"), do: "C"
  defp winning_move("C"), do: "A"

  defp move_score("A"), do: 1 # Rock
  defp move_score("X"), do: 1 # Rock
  defp move_score("B"), do: 2 # Paper
  defp move_score("Y"), do: 2 # Paper
  defp move_score("C"), do: 3 # Scissors
  defp move_score("Z"), do: 3 # Scissors

  defp round_result_score("A", "X"), do: @points_for_a_draw
  defp round_result_score("A", "Y"), do: @points_for_a_win
  defp round_result_score("A", "Z"), do: @points_for_a_loss

  defp round_result_score("B", "X"), do: @points_for_a_loss
  defp round_result_score("B", "Y"), do: @points_for_a_draw
  defp round_result_score("B", "Z"), do: @points_for_a_win

  defp round_result_score("C", "X"), do: @points_for_a_win
  defp round_result_score("C", "Y"), do: @points_for_a_loss
  defp round_result_score("C", "Z"), do: @points_for_a_draw
end

RockPaperScissors.score("input.txt", 2)
