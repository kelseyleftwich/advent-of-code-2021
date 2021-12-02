defmodule Day2Test do
  use ExUnit.Case

  test "part 1 sample input" do
    path = "lib/day2/sampleInput.txt"
    assert Day2.part_1(path) == 150
  end
end
