defmodule Day1 do
  def part_1(path \\ "lib/day1/puzzleInput.txt") do
    path
    |> get_parsed_values()
    |> get_increased_tally()
  end

  def part_2(path \\ "lib/day1/puzzleInput.txt") do
    path
    |> get_parsed_values()
    |> Enum.to_list()
    |> get_windows([])
    |> Enum.reverse()
    |> Stream.map(fn {a, b, c} ->
      a + b + c
    end)
    |> get_increased_tally()
  end

  def get_increased_tally(values) do
    values
    |> Enum.reduce({0, nil}, fn
      value, {0, nil} ->
        {0, value}

      value, {tally, prev_value} ->
        value
        |> Kernel.>(prev_value)
        |> if do
          {tally + 1, value}
        else
          {tally, value}
        end
    end)
    |> elem(0)
  end

  def get_windows([a | [b | [c | tail]]], windows) do
    windows = [{a, b, c} | windows]

    rest = [b | [c | tail]]

    get_windows(rest, windows)
  end

  def get_windows(_, windows) do
    windows
  end

  def get_parsed_values(path) do
    path
    |> FileReader.get_lines()
    |> Stream.map(fn value ->
      value
      |> Integer.parse(10)
      |> elem(0)
    end)
  end
end
