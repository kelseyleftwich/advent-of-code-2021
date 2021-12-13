defmodule Day12 do
  @lower_alphabet_library ?a..?z |> Enum.map(&to_string([&1]))

  def part_1(path \\ "lib/day12/sampleInput_1.txt") do
    segments_map =
      path
      |> get_segments_map()

    segments_map
    |> Map.get("start")
    |> Enum.map(fn point ->
      traverse([point], segments_map)
    end)
    |> flatten()
    |> Enum.filter(fn path -> "end" in path end)
    |> Enum.count()
  end

  def flatten(paths) do
    flattened =
      paths
      |> Enum.reduce([], fn current, acc ->
        current =
          current
          |> flatten_path()

        current
        |> Enum.at(0)
        |> Kernel.is_list()
        |> if do
          current ++ acc
        else
          [current | acc]
        end
      end)

    flattened
    |> Enum.all?(fn row ->
      row
      |> Enum.all?(&is_binary/1)
    end)
    |> if do
      flattened
    else
      flatten(flattened)
    end
  end

  def flatten_path([head | _tail] = result) when is_binary(head) do
    result
  end

  def flatten_path([result]) when is_list(result) do
    flatten_path(result)
  end

  def flatten_path(result) do
    result
    |> Enum.map(&flatten_path/1)
  end

  def traverse([current | _tail] = journey, segments_map) do
    segments_map
    |> Map.get(current)
    |> case do
      nil ->
        journey |> List.flatten()

      ["end"] ->
        ["end" | journey |> List.flatten()]

      points ->
        valid_next_points =
          points
          |> Enum.filter(fn point ->
            # PART 1
            # not (point in journey and point |> String.downcase() == point)

            # PART 2

            is_small_cave = small_cave?(point)

            if not is_small_cave do
              true
            else
              small_caves_in_journey =
                journey
                |> Enum.filter(&small_cave?/1)
                |> Enum.frequencies()

              limit_for_current_cave =
                small_caves_in_journey
                |> Map.values()
                |> Enum.filter(&Kernel.>(&1, 1))
                |> Enum.count()
                |> Kernel.>(0)
                |> if do
                  0
                else
                  1
                end

              can_visit_current_cave =
                small_caves_in_journey
                |> Map.get(point, 0)
                |> Kernel.<=(limit_for_current_cave)

              can_visit_current_cave
            end
          end)

        valid_next_points
        |> Enum.count()
        |> Kernel.>(0)
        |> if do
          valid_next_points
          |> Enum.map(fn valid_next_point ->
            traverse([valid_next_point | journey], segments_map)
          end)
        else
          journey
          |> List.flatten()
        end
    end
  end

  def small_cave?(point) do
    point
    |> String.graphemes()
    |> Enum.all?(&Kernel.in(&1, @lower_alphabet_library))
  end

  def get_segments_map(path) do
    path
    |> FileReader.get_lines()
    |> Enum.reduce(%{}, fn line, acc ->
      [origin, destination] =
        line
        |> String.split("-")

      acc
      |> Map.get_and_update(origin, fn
        nil ->
          {nil, [destination]}

        current_value ->
          {current_value, [destination | current_value]}
      end)
      |> elem(1)
      |> Map.get_and_update(destination, fn
        nil ->
          {nil, [origin]}

        current_value ->
          {current_value, [origin | current_value]}
      end)
      |> elem(1)
    end)
    |> Enum.map(fn {key, value} ->
      value =
        value
        |> Stream.filter(&Kernel.!=(&1, "start"))

      {key, value}
    end)
    |> Map.new()
    |> Map.delete("end")
  end
end
