defmodule Day14 do
  def part_1(path \\ "lib/day14/sampleInput.txt") do
    {polymer_input, rules} =
      path
      |> parse_input()

    polymer_input =
      polymer_input
      |> String.graphemes()
      |> Stream.chunk_every(2, 1, :discard)
      |> Stream.map(&Enum.join/1)
      |> Enum.reduce(%{}, fn pair, acc ->
        acc
        |> Map.get_and_update(pair, fn
          nil -> {nil, 1}
          count -> {count, count + 1}
        end)
        |> elem(1)
      end)

    frequencies =
      1..40
      |> Enum.reduce(polymer_input, fn _i, acc ->
        process_input(acc, rules)
      end)

    poly_counts =
      frequencies
      |> Enum.reduce(%{}, fn {pair, count}, acc ->
        acc
        |> Map.put(pair, count / 2)
      end)
      |> Enum.reduce(%{}, fn {pair, count}, char_counts ->
        pair
        |> String.graphemes()
        |> Enum.reduce(char_counts, fn char, next_counts ->
          next_counts
          |> Map.get_and_update(char, fn
            nil -> {nil, count}
            val -> {val, count + val}
          end)
          |> elem(1)
        end)
      end)

    vals = Map.values(poly_counts)
    round(Enum.max(vals)) - round(Enum.min(vals))
  end

  def process_input(polymer_input, rules) do
    polymer_input
    |> Enum.reduce(%{}, fn
      {pair, count}, acc ->
        inserted_char =
          rules
          |> Map.get(pair)

        [first_char_from_pair, second_char_from_pair] = pair |> String.graphemes()

        first_new_pair = first_char_from_pair |> Kernel.<>(inserted_char)

        second_new_pair = inserted_char |> Kernel.<>(second_char_from_pair)

        acc
        |> Map.update(first_new_pair, count, fn val -> val + count end)
        |> Map.update(second_new_pair, count, fn val -> val + count end)
    end)
  end

  def parse_input(path) do
    [polymer_input | ["" | rules]] =
      path
      |> FileReader.get_lines()

    rules =
      rules
      |> Stream.map(&String.split(&1, " -> "))
      |> Stream.map(fn [pair, insertion] -> {pair, insertion} end)
      |> Map.new()

    {polymer_input, rules}
  end
end
