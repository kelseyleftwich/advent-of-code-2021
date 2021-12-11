defmodule Day11.Draw do
  def highlight_line(line) when is_binary(line) do
    line
    |> String.graphemes()
    |> Enum.map(fn char ->
      color =
        char
        |> Kernel.==("0")
        |> if do
          IO.ANSI.yellow()
        else
          IO.ANSI.light_black()
        end

      "#{color}#{char}"
    end)
    |> Enum.join()
  end

  def line_done({line_index, line}, canvas_height) do
    offset = canvas_height - line_index

    line = highlight_line(line)

    offset
    |> IO.ANSI.cursor_up()
    |> Kernel.<>(line)
    |> Kernel.<>("\r")
    |> Kernel.<>(IO.ANSI.cursor_down(offset))
    |> IO.write()
  end
end
