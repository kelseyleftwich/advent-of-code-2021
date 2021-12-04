defmodule Day3 do
  def part_1(path \\ "lib/day3/sampleInput.txt") do
    frequecies =
      path
      |> FileReader.get_lines()
      |> get_frequencies()

    {gamma, ""} =
      frequecies
      |> Enum.map(fn counts -> get_gamma_digit(counts) end)
      |> Enum.join("")
      |> Integer.parse(2)

    {epsilon, ""} =
      frequecies
      |> Enum.map(&get_epsilon_digit(&1))
      |> Enum.join("")
      |> Integer.parse(2)

    gamma * epsilon
  end

  def part_2(path \\ "lib/day3/sampleInput.txt") do
    lines =
      path
      |> FileReader.get_lines()

    frequencies =
      lines
      |> get_frequencies()

    oxygen =
      lines
      |> oxygen_gen(frequencies, 0)

    co2 =
      lines
      |> co2_gen(frequencies, 0)

    oxygen * co2
  end

  def oxygen_gen([final], _, _) do
    final
    |> Integer.parse(2)
    |> elem(0)
  end

  def oxygen_gen(lines, frequencies, position) do
    current =
      frequencies
      |> Enum.at(position)

    most_common_digit =
      current
      |> get_gamma_digit()

    lines =
      lines
      |> Enum.filter(fn line -> line |> String.at(position) == most_common_digit end)

    frequencies =
      lines
      |> get_frequencies()

    oxygen_gen(lines, frequencies, position + 1)
  end

  def co2_gen([final], _, _) do
    final
    |> Integer.parse(2)
    |> elem(0)
  end

  def co2_gen(lines, frequencies, position) do
    current =
      frequencies
      |> Enum.at(position)

    least_common_digit =
      current
      |> get_epsilon_digit()

    lines =
      lines
      |> Enum.filter(fn line -> line |> String.at(position) == least_common_digit end)

    frequencies =
      lines
      |> get_frequencies()

    co2_gen(lines, frequencies, position + 1)
  end

  def get_frequencies(lines) do
    lines
    |> Stream.map(fn line -> line |> String.graphemes() end)
    |> Enum.reduce(%{}, fn digits, acc ->
      digits_length = digits |> Enum.count() |> Kernel.-(1)

      0..digits_length
      |> Enum.reduce(acc, fn index, char_map ->
        digit = digits |> Enum.at(index)

        char_map
        |> update_char_map(index, digit)
      end)
    end)
    |> Enum.map(fn {_index, place} ->
      %{"0" => _zeros_count, "1" => _ones_count} =
        place
        |> Enum.frequencies()
        |> Map.put_new("0", 0)
        |> Map.put_new("1", 0)
    end)
  end

  def get_gamma_digit(%{"0" => zeros_count, "1" => ones_count}) when zeros_count > ones_count,
    do: "0"

  def get_gamma_digit(_), do: "1"

  def get_epsilon_digit(%{"0" => zeros_count, "1" => ones_count}) when ones_count < zeros_count,
    do: "1"

  def get_epsilon_digit(_), do: "0"

  def update_char_map(char_map, index, char) do
    char_map
    |> Map.update(index, [char], fn existing -> [char | existing] end)
  end
end
