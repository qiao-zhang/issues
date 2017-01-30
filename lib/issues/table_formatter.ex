defmodule Issues.TableFormatter do
  import Enum, only: [ zip: 2, map: 2, max: 1, map_join: 3 ]
  @moduledoc false
  def split_into_columns(rows, headers) do
    for header <- headers do
      for row <- rows, do: row[header] |> printable
    end
  end

  def widths_of(columns, headers) do
    for {c, h} <- zip(columns, headers) do
      [to_string(h) | c] |> map(&String.length/1) |> max
    end
  end

  def put_separator(widths) do
    IO.puts map_join(widths, "-+-", &(String.duplicate("-", &1)))
  end

  def format_for(widths) do
    map_join(widths, " | ", &("~-#{&1}s")) <> "~n"
  end

  defp printable(str) when is_binary(str), do: str
  defp printable(str), do: to_string(str)

end