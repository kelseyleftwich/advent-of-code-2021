defmodule Day8 do
  def part_1(path \\ "lib/day8/sampleInput.txt") do
    path
    |> FileReader.get_lines()
    |> Enum.reduce([], fn line, acc ->
      digits =
        line
        |> get_digits_1_4_7_8()

      digits ++ acc
    end)
    |> Enum.count()
  end

  def part_2(path \\ "lib/day8/sampleInput.txt") do
    path
    |> FileReader.get_lines()
    |> Enum.reduce(0, fn line, acc ->
      line |> decode_output() |> Kernel.+(acc)
    end)
  end

  def decode_output(line) do
    digits_map =
      line
      |> get_decoded_digits()

    line
    |> get_output_digits()
    |> Enum.map(fn digit ->
      digits_map
      |> Map.get(digit |> String.graphemes() |> Enum.sort() |> Enum.join(""))
      |> Integer.to_string()
    end)
    |> Enum.join("")
    |> Integer.parse()
    |> elem(0)
  end

  def get_decoded_digits(line) do
    one_segments = get_segments_for_count(line, 2)
    four_segments = get_segments_for_count(line, 4)
    seven_segments = get_segments_for_count(line, 3)
    eight_segments = get_segments_for_count(line, 7)
    three_segments = get_three_segments(line, one_segments)
    nine_segments = get_nine_segments(line, four_segments)
    zero_segments = get_zero_segments(line, seven_segments, nine_segments)

    six_segments = get_six_segments(line, zero_segments, nine_segments)

    five_segments = get_five_segments(line, six_segments)
    two_segments = get_two_segments(line, five_segments, three_segments)

    %{
      (zero_segments |> Enum.sort() |> Enum.join("")) => 0,
      (one_segments |> Enum.sort() |> Enum.join("")) => 1,
      (two_segments |> Enum.sort() |> Enum.join("")) => 2,
      (three_segments |> Enum.sort() |> Enum.join("")) => 3,
      (four_segments |> Enum.sort() |> Enum.join("")) => 4,
      (five_segments |> Enum.sort() |> Enum.join("")) => 5,
      (six_segments |> Enum.sort() |> Enum.join("")) => 6,
      (seven_segments |> Enum.sort() |> Enum.join("")) => 7,
      (eight_segments |> Enum.sort() |> Enum.join("")) => 8,
      (nine_segments |> Enum.sort() |> Enum.join("")) => 9
    }
  end

  def get_two_segments(line, five_segments, three_segments) do
    line
    |> get_digits()
    |> Stream.filter(&(String.length(&1) == 5))
    |> Stream.filter(&(&1 != Enum.join(five_segments)))
    |> Enum.filter(&(&1 != Enum.join(three_segments)))
    |> case do
      [] ->
        []

      [result | _] ->
        result |> String.graphemes()
    end
  end

  def get_five_segments(line, six_segments) do
    six_segments = six_segments |> MapSet.new()

    line
    |> get_digits()
    |> Stream.filter(&(String.length(&1) == 5))
    |> Enum.filter(fn digit ->
      digit
      |> String.graphemes()
      |> MapSet.new()
      |> MapSet.subset?(six_segments)
    end)
    |> case do
      [] ->
        []

      [result | _] ->
        result |> String.graphemes()
    end
  end

  def get_six_segments(line, zero_segments, nine_segments) do
    line
    |> get_digits()
    |> Stream.filter(&(String.length(&1) == 6))
    |> Stream.filter(&(&1 != Enum.join(zero_segments)))
    |> Enum.filter(&(&1 != Enum.join(nine_segments)))
    |> case do
      [] ->
        []

      [result | _] ->
        result |> String.graphemes()
    end
  end

  def get_zero_segments(line, seven_segments, nine_segments) do
    line
    |> get_digits()
    |> Stream.filter(&(String.length(&1) == 6))
    |> Stream.filter(&(&1 != Enum.join(nine_segments)))
    |> Enum.filter(fn digit ->
      seven_segments
      |> Enum.all?(fn segment -> String.contains?(digit, segment) end)
    end)
    |> case do
      [] ->
        []

      [result | _] ->
        result |> String.graphemes()
    end
  end

  def get_nine_segments(line, four_segments) do
    line
    |> get_digits()
    |> Stream.filter(&(String.length(&1) == 6))
    |> Enum.filter(fn digit ->
      four_segments
      |> Enum.all?(fn segment -> String.contains?(digit, segment) end)
    end)
    |> case do
      [] ->
        []

      [result | _] ->
        result |> String.graphemes()
    end
  end

  def get_three_segments(line, one_segments) do
    line
    |> get_digits()
    |> Stream.filter(&(String.length(&1) == 5))
    |> Enum.filter(fn digit ->
      one_segments
      |> Enum.all?(fn segment -> String.contains?(digit, segment) end)
    end)
    |> case do
      [] ->
        []

      [result | _] ->
        result |> String.graphemes()
    end
  end

  def get_segments_for_count(line, count) do
    line
    |> get_digits()
    |> Enum.filter(fn digit ->
      digit
      |> String.length()
      |> Kernel.==(count)
    end)
    |> case do
      [] ->
        []

      [result | _] ->
        result |> String.graphemes()
    end
  end

  def get_digits_1_4_7_8(line) do
    line
    |> get_output_digits()
    |> Enum.filter(fn digit ->
      digit
      |> String.length()
      |> Kernel.in([2, 3, 4, 7])
    end)
  end

  def get_output_digits(line) do
    line
    |> String.split(" | ")
    |> Enum.at(1)
    |> String.split(" ")
  end

  def get_digits(line) do
    line
    |> String.replace(" | ", " ")
    |> String.split(" ")
  end
end
