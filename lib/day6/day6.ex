defmodule Day6 do
  def part_1(path \\ "lib/day6/sampleInput.txt") do
    path
    |> get_initial_state()
    |> simulate(80)
    |> Map.values()
    |> Enum.sum()
  end

  def part_2(path \\ "lib/day6/sampleInput.txt") do
    path
    |> get_initial_state()
    |> simulate(256)
    |> Map.values()
    |> Enum.sum()
  end

  def simulate(state, 0) do
    state
  end

  def simulate(state, days_remaining) do
    state =
      state
      |> increment_state()

    simulate(state, days_remaining - 1)
  end

  def increment_state(state) do
    new_fish_count = Map.get(state, 0, 0)

    state =
      0..7
      |> Enum.reduce(%{}, fn index, frequencies ->
        update_frequency(index, frequencies, state)
      end)

    state
    |> Map.put(8, new_fish_count)
  end

  def update_frequency(6, frequencies, state) do
    old_fish = Map.get(state, 0, 0)
    new_fish = Map.get(state, 7, 0)

    frequencies
    |> Map.put(6, old_fish + new_fish)
  end

  def update_frequency(index, frequencies, state) do
    access_index =
      index
      |> Kernel.+(1)

    value = Map.get(state, access_index, 0)

    frequencies
    |> Map.put(index, value)
  end

  def get_initial_state(path) do
    path
    |> FileReader.get_lines()
    |> List.first()
    |> String.split(",")
    |> Enum.map(fn num ->
      {num, ""} = num |> Integer.parse(10)
      num
    end)
    |> Enum.frequencies()
  end
end
