defmodule Day7 do
  def part_1(path \\ "lib/day7/sampleInput.txt") do
    crabs = path |> get_crabs()

    max_crab = Enum.max(crabs)

    0..max_crab
    |> Enum.reduce({nil, 999_999_999}, fn position, {best_position, best_fuel} ->
      fuel_for_pos =
        crabs
        |> Enum.reduce(0, fn crab, fuel_acc ->
          crab
          |> Kernel.-(position)
          |> Kernel.abs()
          |> Kernel.+(fuel_acc)
        end)

      fuel_for_pos
      |> Kernel.<(best_fuel)
      |> if do
        {position, fuel_for_pos}
      else
        {best_position, best_fuel}
      end
    end)
  end

  def part_2(path \\ "lib/day7/sampleInput.txt") do
    crabs = path |> get_crabs()

    max_crab = Enum.max(crabs)

    0..max_crab
    |> Enum.reduce({nil, 999_999_999}, fn position, {best_position, best_fuel} ->
      fuel_for_pos =
        crabs
        |> Enum.reduce(0, fn crab, fuel_acc ->
          n =
            crab
            |> Kernel.-(position)
            |> Kernel.abs()

          n
          |> Kernel.*(n + 1)
          |> Kernel./(2)
          |> Kernel.+(fuel_acc)
        end)

      fuel_for_pos
      |> Kernel.<(best_fuel)
      |> if do
        {position, fuel_for_pos}
      else
        {best_position, best_fuel}
      end
    end)
  end

  def get_crabs(path) do
    path
    |> FileReader.get_lines()
    |> List.first()
    |> String.split(",")
    |> Enum.map(fn crab -> Integer.parse(crab, 10) |> elem(0) end)
    |> Enum.sort()
  end
end
