defmodule Day13.Draw do
  def highlight_line(line) when is_binary(line) do
    line
    |> String.graphemes()
    |> Enum.map(fn char ->
      color =
        char
        |> Kernel.==("#")
        |> if do
          IO.ANSI.yellow()
        else
          IO.ANSI.light_black()
        end

      "#{color}#{char}"
    end)
    |> Enum.join()
  end

  def draw_line({line, line_index}, canvas_height) do
    draw_line({line, line_index}, canvas_height, false)
  end

  def draw_line({line, line_index}, canvas_height, highlight) do
    offset = canvas_height - line_index

    line =
      if highlight do
        highlight_line(line)
      else
        line
      end

    offset
    |> IO.ANSI.cursor_up()
    |> Kernel.<>(line)
    |> Kernel.<>("\r")
    |> Kernel.<>(IO.ANSI.cursor_down(offset))
    |> IO.write()
  end
end
