defmodule Day4 do
  def part_1(path \\ "lib/day4/sampleInput.txt") do
    [numbers_to_call | card_lines] =
      path
      |> FileReader.get_lines()

    cards = get_cards(card_lines)

    numbers_to_call = numbers_to_call |> String.split(",")

    {card, last_number} =
      cards
      |> play(numbers_to_call)

    {last_number, ""} = Integer.parse(last_number)

    card
    |> calculate_winning_score()
    |> Kernel.*(last_number)
  end

  def part_2(path \\ "lib/day4/sampleInput.txt") do
    [numbers_to_call | card_lines] =
      path
      |> FileReader.get_lines()

    cards = get_cards(card_lines)

    numbers_to_call = numbers_to_call |> String.split(",")

    {card, last_number} =
      cards
      |> lose(numbers_to_call)

    {last_number, ""} = Integer.parse(last_number)

    card
    |> calculate_winning_score()
    |> Kernel.*(last_number)
  end

  def calculate_winning_score(card) do
    card
    |> Enum.reduce(0, fn line, acc ->
      line
      |> Stream.filter(fn cell -> cell != "X" end)
      |> Stream.map(fn cell ->
        {parsed_cell, ""} = Integer.parse(cell)
        parsed_cell
      end)
      |> Enum.sum()
      |> Kernel.+(acc)
    end)
  end

  def play(cards, [next | remaining_numbers_to_call]) do
    marked_cards =
      cards
      |> Enum.map(&mark_card(&1, next))

    winning_cards =
      marked_cards
      |> Enum.filter(&card_has_bingo?(&1))

    winning_cards
    |> Enum.count()
    |> Kernel.>(0)
    |> if do
      winning_card =
        winning_cards
        |> List.first()

      {winning_card, next}
    else
      play(marked_cards, remaining_numbers_to_call)
    end
  end

  def lose(cards, [next | remaining_numbers_to_call]) do
    marked_cards =
      cards
      |> Enum.map(&mark_card(&1, next))

    losing_cards =
      marked_cards
      |> Enum.filter(fn card -> not card_has_bingo?(card) end)

    losing_cards
    |> Enum.count()
    |> Kernel.==(0)
    |> if do
      last_card =
        marked_cards
        |> List.first()

      {last_card, next}
    else
      lose(losing_cards, remaining_numbers_to_call)
    end
  end

  def get_cards(card_lines) do
    card_lines
    |> Enum.filter(fn line -> line != "" end)
    |> Enum.chunk_every(5)
    |> Enum.map(fn card ->
      card
      |> Enum.map(fn line ->
        line
        |> String.trim()
        |> String.replace(~r/ +/, " ")
        |> String.split(" ")
      end)
    end)
  end

  def mark_card(card, called_number) do
    card
    |> Enum.map(fn line ->
      line
      |> Enum.map(fn cell ->
        if cell == called_number do
          "X"
        else
          cell
        end
      end)
    end)
  end

  def card_has_bingo?(card) do
    has_vert_bingo =
      card
      |> card_has_vertical_bingo?()

    has_hori_bingo = card |> card_has_horizontal_bingo?()

    has_vert_bingo or has_hori_bingo
  end

  def card_has_vertical_bingo?(card) do
    0..4
    |> Enum.reduce(false, fn column_index, acc ->
      card
      |> Enum.all?(fn line ->
        line
        |> Enum.at(column_index)
        |> Kernel.==("X")
      end)
      |> Kernel.or(acc)
    end)
  end

  def card_has_horizontal_bingo?(card) do
    card
    |> Enum.any?(fn cells ->
      cells
      |> Enum.all?(fn cell -> cell == "X" end)
    end)
  end
end
