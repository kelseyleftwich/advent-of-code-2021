defmodule Day2 do
  def part_1(path) do
    path
    |> FileReader.get_lines()
    |> Enum.reduce({0, 0}, fn line, {depth, horizontal} ->
      line
      |> parse_line({depth, horizontal})
    end)
    |> Tuple.product()
  end

  def parse_line(line, location) when is_binary(line) do
    [direction, units] = line |> String.split(" ")
    {units, ""} = Integer.parse(units)
    parse_line([direction, units], location)
  end

  def parse_line(["forward", units], {depth, horizontal}) do
    {depth, horizontal + units}
  end

  def parse_line(["down", units], {depth, horizontal}) do
    {depth + units, horizontal}
  end

  def parse_line(["up", units], {depth, horizontal}) do
    {depth - units, horizontal}
  end
end
