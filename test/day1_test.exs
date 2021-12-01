defmodule Day1Test do
  use ExUnit.Case

  test "part 1 sample input" do
    assert Day1.part_1("lib/day1/sampleInput.txt") == 7
  end

  test "part 2 sample input" do
    assert Day1.part_2("lib/day1/sampleInput.txt") == 5
  end
end
