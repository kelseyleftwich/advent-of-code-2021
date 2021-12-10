defmodule Day9 do
  def part_1(path \\ "lib/day9/sampleInput.txt") do
    height_map = get_height_map(path)

    {height, width} = get_height_and_width(height_map)

    0..(height - 1)
    |> Enum.map(fn y_coord ->
      0..(width - 1)
      |> Enum.map(fn x_coord -> {x_coord, y_coord} end)
    end)
    |> Enum.flat_map(fn line ->
      line
      |> Enum.map(fn coords ->
        value = get_coord_value(coords, height_map)

        get_surrounding_coords(coords, {width, height})
        |> Enum.map(fn surrounding_coord ->
          get_coord_value(surrounding_coord, height_map)
        end)
        |> Enum.all?(&(&1 > value))
        |> if do
          value
        else
          nil
        end
      end)
    end)
    |> Stream.filter(& &1)
    |> Stream.map(&(&1 + 1))
    |> Enum.sum()
  end

  def part_2(path \\ "lib/day9/sampleInput.txt") do
    height_map = get_height_map(path)

    {height, width} = get_height_and_width(height_map)

    0..(height - 1)
    |> Enum.map(fn y_coord ->
      0..(width - 1)
      |> Enum.map(fn x_coord -> {x_coord, y_coord} end)
    end)
    |> Enum.flat_map(fn line ->
      line
      |> Enum.map(fn coords ->
        value = get_coord_value(coords, height_map)

        get_surrounding_coords(coords, {width, height})
        |> Enum.map(fn surrounding_coord ->
          get_coord_value(surrounding_coord, height_map)
        end)
        |> Enum.all?(&(&1 > value))
        |> if do
          coords
        else
          nil
        end
      end)
    end)
    |> Enum.filter(& &1)
    |> Enum.map(fn coords -> get_basin_coords(coords, height_map, []) end)
    |> Enum.map(fn coords ->
      coords
      |> List.flatten()
      |> Enum.uniq()
      |> Enum.count()
    end)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.product()
  end

  def get_basin_coords([], _, basin) do
    basin
  end

  def get_basin_coords(coords, height_map, basin) do
    value = get_coord_value(coords, height_map)
    {height, width} = get_height_and_width(height_map)

    get_surrounding_coords(coords, {width, height})
    |> Enum.map(fn surrounding_coord ->
      surrounding_coord_value = get_coord_value(surrounding_coord, height_map)
      {surrounding_coord, surrounding_coord_value}
    end)
    |> Enum.filter(fn {_surrounding_coord, surrounding_coord_value} ->
      surrounding_coord_value > value and surrounding_coord_value < 9
    end)
    |> case do
      [] ->
        get_basin_coords([], height, [coords | basin])

      filtered_coords ->
        filtered_coords
        |> Enum.map(fn {surrounding_coord, _} ->
          get_basin_coords(surrounding_coord, height_map, [coords | basin])
        end)
    end

    # |> Enum.flat_map(fn {surrounding_coord, _} ->
    #   get_basin_coords(surrounding_coord, height_map)
    # end)
  end

  def get_surrounding_coords({x, y}, {width, height}) do
    [
      {x, y - 1},
      {x, y + 1},
      {x - 1, y},
      {x + 1, y}
    ]
    |> Enum.filter(fn {x, y} ->
      x >= 0 and
        y >= 0 and
        x < width and
        y < height
    end)
  end

  def get_coord_value({x, y}, height_map) do
    height_map
    |> Enum.at(y)
    |> Enum.at(x)
  end

  def get_height_and_width(height_map) do
    width = height_map |> List.first() |> Enum.count()
    height = height_map |> Enum.count()
    {height, width}
  end

  def get_height_map(path) do
    path
    |> FileReader.get_lines()
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.map(fn cell -> cell |> Integer.parse(10) |> elem(0) end)
    end)
  end
end
