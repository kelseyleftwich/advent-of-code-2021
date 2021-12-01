defmodule FileReader do
  def get_lines(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n")
  end
end
