defmodule Day5 do
  def part_1(path \\ "lib/day5/sampleInput.txt") do
    path
    |> FileReader.get_lines()
    |> get_vent_lines()
    |> get_vertical_and_horizontal_vent_lines()
    |> get_overlapping_vents()
  end

  def part_2(path \\ "lib/day5/sampleInput.txt") do
    path
    |> FileReader.get_lines()
    |> get_vent_lines()
    |> get_overlapping_vents()
  end

  def get_overlapping_vents(vent_lines) do
    vent_lines
    |> mark_diagram()
    |> List.flatten()
    |> Enum.count(fn cell -> cell > 1 end)
  end

  def mark_diagram(vent_lines) do
    diagram = get_empty_diagram(vent_lines)

    vent_lines
    |> get_vent_lines_points()
    |> Enum.reduce(diagram, fn {x, y}, acc ->
      acc
      |> List.update_at(y, fn row ->
        row |> List.update_at(x, fn cell -> cell + 1 end)
      end)
    end)
  end

  def get_vent_lines_points(vent_lines) do
    vent_lines
    |> Enum.flat_map(fn line ->
      get_line_points(line)
    end)
  end

  def get_line_points([{x1, y1}, {x2, y2}]) do
    x_points = x1..x2 |> Enum.to_list()
    y_points = y1..y2 |> Enum.to_list()

    x_points
    |> get_points(y_points)
  end

  def get_points([x_point], y_points) do
    y_points
    |> Enum.map(fn y ->
      {x_point, y}
    end)
  end

  def get_points(x_points, [y_point]) do
    x_points
    |> Enum.map(fn x ->
      {x, y_point}
    end)
  end

  def get_points(x_points, y_points) do
    x_points
    |> Stream.with_index()
    |> Enum.map(fn {x, index} ->
      y = y_points |> Enum.at(index)
      {x, y}
    end)
  end

  def get_empty_diagram(vent_lines) do
    vent_lines
    |> get_max_x_and_y()
    |> draw_diagram()
  end

  def draw_diagram({max_x, max_y}) do
    List.duplicate(0, max_x + 1)
    |> List.duplicate(max_y + 1)
  end

  def get_max_x_and_y(vent_lines) do
    x =
      vent_lines
      |> Stream.flat_map(fn [{x1, _}, {x2, _}] ->
        [x1, x2]
      end)
      |> Enum.max()

    y =
      vent_lines
      |> Stream.flat_map(fn [{_, y1}, {_, y2}] ->
        [y1, y2]
      end)
      |> Enum.max()

    {x, y}
  end

  def get_vertical_and_horizontal_vent_lines(vent_lines) do
    vent_lines
    |> Enum.filter(fn [{x1, y1}, {x2, y2}] ->
      x1 == x2 or y1 == y2
    end)
  end

  def get_vent_lines(lines) do
    lines
    |> Enum.map(fn line ->
      line
      |> String.split(" -> ")
      |> Enum.map(fn coord ->
        [x, y] =
          coord
          |> String.split(",")
          |> Enum.map(fn digit -> Integer.parse(digit, 10) |> elem(0) end)

        {x, y}
      end)
    end)
  end
end
