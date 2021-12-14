defmodule Day13 do
  def part_1(path \\ "lib/day13/sampleInput.txt") do
    {dots, folds} = get_dots_and_folds_from_input(path)

    initial_sheet = get_initial_sheet(dots)

    clear()

    folded_sheet =
      folds
      |> Enum.reduce(initial_sheet, &fold/2)

    folded_sheet
    |> draw_sheet()

    folded_sheet
    |> List.flatten()
    |> Enum.count(&(&1 == "#"))
  end

  def fold({"y", value}, sheet) do
    top =
      sheet
      |> Enum.slice(0..(value - 1))

    bottom =
      sheet
      |> Enum.slice((value + 1)..-1)
      |> Enum.reverse()

    get_folded(top, bottom)
  end

  def fold({"x", value}, sheet) do
    left =
      sheet
      |> Enum.map(&Enum.slice(&1, 0..(value - 1)))

    right =
      sheet
      |> Stream.map(&Enum.slice(&1, (value + 1)..-1))
      |> Enum.map(&Enum.reverse/1)

    get_folded(left, right)
  end

  def get_folded(bigger, smaller) do
    offset = Enum.count(bigger) - Enum.count(smaller)

    bigger
    |> Stream.with_index()
    |> Enum.map(fn
      {row, row_index} when row_index < offset ->
        row

      {row, row_index} ->
        row
        |> Stream.with_index()
        |> Enum.map(fn
          {"#", _cell_index} ->
            "#"

          {".", cell_index} ->
            smaller
            |> Enum.at(row_index - offset)
            |> case do
              nil ->
                "."

              r ->
                r |> Enum.at(cell_index, ".")
            end
        end)
    end)
  end

  def draw_sheet(sheet) do
    height = Enum.count(sheet)

    sheet
    |> Enum.map(&Enum.join/1)
    |> Stream.with_index()
    |> Enum.each(&Day13.Draw.draw_line(&1, height))
  end

  def clear() do
    IO.write(IO.ANSI.clear() <> IO.ANSI.home())
  end

  def get_initial_sheet(dots) do
    blank_matrix =
      dots
      |> get_blank_matrix()

    dots
    |> Enum.reduce(blank_matrix, fn [x, y], acc ->
      acc
      |> List.update_at(y, fn row ->
        row |> List.update_at(x, fn _ -> "#" end)
      end)
    end)
  end

  def get_blank_matrix(dots) do
    max_x = get_max_x(dots)
    max_y = get_max_y(dots)

    0..max_y
    |> Enum.map(fn _row ->
      0..max_x
      |> Enum.map(fn _col -> "." end)
    end)
  end

  def get_max_x(dots) do
    dots |> Stream.map(&Enum.at(&1, 0)) |> Enum.max()
  end

  def get_max_y(dots) do
    dots |> Stream.map(&Enum.at(&1, 1)) |> Enum.max()
  end

  def get_dots_and_folds_from_input(path) do
    {dots, folds} =
      path
      |> FileReader.get_lines()
      |> Enum.split_while(fn elem -> elem != "" end)

    dots = parse_dots(dots)

    folds = parse_folds(folds)
    {dots, folds}
  end

  def parse_folds(folds) do
    folds
    |> tl()
    |> Stream.map(&String.replace(&1, "fold along ", ""))
    |> Stream.map(&String.split(&1, "="))
    |> Enum.map(fn [axis, coord] ->
      coord = coord |> Integer.parse() |> elem(0)
      {axis, coord}
    end)
  end

  def parse_dots(dots) do
    dots
    |> Stream.map(&String.split(&1, ","))
    |> Enum.map(fn coords ->
      coords
      |> Enum.map(fn coord ->
        coord
        |> Integer.parse(10)
        |> elem(0)
      end)
    end)
  end
end
