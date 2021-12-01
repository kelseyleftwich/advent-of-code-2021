defmodule Day1 do
  def solve(path \\ "lib/day1/puzzleInput.txt") do
    path
    |> FileReader.get_lines()
    |> Stream.map(fn value ->
      value
      |> Integer.parse(10)
      |> elem(0)
    end)
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
end
