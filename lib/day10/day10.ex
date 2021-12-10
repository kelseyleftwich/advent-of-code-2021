defmodule Day10 do
  def part_1(path \\ "lib/day10/sampleInput.txt") do
    path
    |> FileReader.get_lines()
    |> Stream.map(&String.graphemes(&1))
    |> Stream.map(&check_line(&1, []))
    |> Stream.filter(&is_binary/1)
    |> Stream.map(&get_points/1)
    |> Enum.sum()
  end

  def part_2(path \\ "lib/day10/sampleInput.txt") do
    points =
      path
      |> FileReader.get_lines()
      |> Stream.map(&String.graphemes(&1))
      |> Stream.map(&check_line(&1, []))
      |> Stream.filter(&is_list/1)
      |> Enum.map(&get_completion_points/1)
      |> Enum.sort()

    middle_index = points |> length() |> div(2)
    Enum.at(points, middle_index)
  end

  def get_completion_points(chars), do: get_completion_points(chars, 0)

  def get_completion_points([], points), do: points

  def get_completion_points([current_char | tail], points) do
    points_for_current_char =
      current_char
      |> case do
        "(" -> 1
        "[" -> 2
        "{" -> 3
        "<" -> 4
      end

    total_points =
      points
      |> Kernel.*(5)
      |> Kernel.+(points_for_current_char)

    get_completion_points(tail, total_points)
  end

  def get_points(")"), do: 3
  def get_points("]"), do: 57
  def get_points("}"), do: 1197
  def get_points(">"), do: 25137

  def check_line([], stack), do: stack

  def check_line([")" | tail], ["(" | rest]), do: check_line(tail, rest)
  def check_line([")" | _tail], _stack), do: ")"

  def check_line(["]" | tail], ["[" | rest]), do: check_line(tail, rest)
  def check_line(["]" | _tail], _), do: "]"

  def check_line([">" | tail], ["<" | rest]), do: check_line(tail, rest)
  def check_line([">" | _tail], _), do: ">"

  def check_line(["}" | tail], ["{" | rest]), do: check_line(tail, rest)
  def check_line(["}" | _tail], _), do: "}"

  def check_line([head | tail], stack), do: check_line(tail, [head | stack])
end
