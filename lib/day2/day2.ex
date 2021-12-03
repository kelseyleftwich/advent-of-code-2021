defmodule Day2 do
  def part_1(path) do
    path
    |> FileReader.get_lines()
    |> Enum.reduce({0, 0, 0}, fn line, {depth, horizontal, aim} ->
      line
      |> parse_line({depth, horizontal, aim})
    end)
    |> Tuple.delete_at(2)
    |> Tuple.product()
  end

  def parse_line(line, location) when is_binary(line) do
    [direction, units] = line |> String.split(" ")
    {units, ""} = Integer.parse(units)
    parse_line([direction, units], location)
  end

  # It increases your horizontal position by X units.
  # It increases your depth by your aim multiplied by X.
  def parse_line(["forward", units], {depth, horizontal, aim}) do
    {depth + aim * units, horizontal + units, aim}
  end

  def parse_line(["down", units], {depth, horizontal, aim}) do
    {depth, horizontal, aim + units}
  end

  def parse_line(["up", units], {depth, horizontal, aim}) do
    {depth, horizontal, aim - units}
  end
end
