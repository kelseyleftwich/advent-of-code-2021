defmodule Day11 do
  def solve(path \\ "lib/day11/sampleInput.txt") do
    IO.write(IO.ANSI.clear() <> IO.ANSI.home())

    initial_state =
      path
      |> get_initial_state()

    height = initial_state |> Enum.count()
    width = initial_state |> Enum.at(0) |> elem(1) |> Enum.count()

    initial_state
    |> draw()

    # edit range for PART 1
    {_, flash_count} =
      1..2000
      |> Enum.reduce({initial_state, 0}, fn step, {current_state, flash_count} ->
        advanced_state =
          current_state
          |> advance()

        advanced_state
        |> draw()

        step_flash_count =
          advanced_state
          |> to_drawable_list
          |> Stream.map(&elem(&1, 1))
          |> Stream.map(fn line ->
            line |> String.graphemes() |> Enum.frequencies() |> Map.get("0", 0)
          end)
          |> Enum.sum()

        flash_count =
          step_flash_count
          |> Kernel.+(flash_count)

        # PART 2
        if step_flash_count == height * width do
          IO.write("#{IO.ANSI.green()}#{step} 🐙💡 #{IO.ANSI.reset()}\n")
          Process.exit(Kernel.self(), :normal)
        end

        Process.sleep(100)

        {advanced_state, flash_count}
      end)

    IO.write("\n#{IO.ANSI.green()}#{flash_count} 🐙\n\n\n")
  end

  def to_drawable_list(state) do
    state
    |> Enum.map(fn {row, line} ->
      line =
        line
        |> Enum.map(&elem(&1, 1))
        |> Enum.join()

      {row, line}
    end)
  end

  def draw(state) do
    height = state |> Enum.count()

    state |> to_drawable_list() |> Enum.each(&Day11.Draw.line_done(&1, height))
  end

  def advance(state) do
    state
    |> Enum.map(fn {row_index, line} ->
      line =
        line
        |> Enum.map(fn {col_index, val} ->
          {col_index, val + 1}
        end)
        |> Map.new()

      {row_index, line}
    end)
    |> Map.new()
    |> ripple()
    |> zero_out_flashes()
  end

  def zero_out_flashes(state) do
    state
    |> Enum.map(fn {row, line} ->
      line =
        line
        |> Enum.map(fn
          {col, cell} ->
            if cell > 9 do
              {col, 0}
            else
              {col, cell}
            end
        end)
        |> Map.new()

      {row, line}
    end)
    |> Map.new()
  end

  def ripple(new_state) do
    height = new_state |> Enum.count()

    width = new_state |> Map.get(0) |> Enum.count()

    ripple_origins =
      new_state
      |> get_ripple_origins()

    new_state = new_state |> zero_out_flashes()

    state =
      ripple_origins
      |> Enum.reduce(new_state, fn origin, acc_a ->
        origin
        |> get_surrounding_coords()
        |> Enum.reduce(acc_a, fn {row, column}, acc_b ->
          if row >= height or column >= width or row < 0 or column < 0 do
            acc_b
          else
            acc_b
            |> Kernel.get_and_update_in([row, column], fn
              0 -> {0, 0}
              val -> {val, val + 1}
            end)
            |> elem(1)
          end
        end)
      end)

    state
    |> should_ripple_again()
    |> if do
      ripple(state)
    else
      state
    end
  end

  def should_ripple_again(state) do
    state
    |> Enum.reduce(false, fn {_, line}, row_acc ->
      line
      |> Enum.reduce(false, fn {_, val}, col_acc -> col_acc or val > 9 end)
      |> Kernel.or(row_acc)
    end)
  end

  def get_surrounding_coords({row, column}) do
    [
      # above and below
      {row + 1, column},
      {row - 1, column},

      # left and right
      {row, column + 1},
      {row, column - 1},

      # top diagonal
      {row + 1, column + 1},
      {row + 1, column - 1},
      # bottom diagonal
      {row - 1, column + 1},
      {row - 1, column - 1}
    ]
    |> Enum.filter(fn {row, column} ->
      row >= 0 and column >= 0
    end)
  end

  def get_ripple_origins(new_state) do
    new_state
    |> Enum.map(fn {row, line} ->
      line
      |> Enum.map(fn {col, val} ->
        if val > 9 do
          {0, {row, col}}
        else
          nil
        end
      end)
      |> Stream.filter(fn
        {0, _coords} -> true
        _ -> false
      end)
      |> Enum.map(&elem(&1, 1))
    end)
    |> List.flatten()
  end

  def get_initial_state(path) do
    path
    |> FileReader.get_lines()
    |> Stream.map(&String.graphemes/1)
    |> Enum.map(fn line ->
      line
      |> Enum.map(fn char -> char |> Integer.parse(10) |> elem(0) end)
      |> Stream.with_index()
      |> Stream.map(fn {cell, col_num} -> {col_num, cell} end)
      |> Map.new()
    end)
    |> Stream.with_index()
    |> Stream.map(fn {cell, row_num} -> {row_num, cell} end)
    |> Map.new()
  end
end
