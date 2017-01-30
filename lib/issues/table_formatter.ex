defmodule Issues.TableFormatter do
  import Enum, only: [ zip: 2, map: 2, max: 1, map_join: 3, each: 2 ]
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

  def put_one_row(row, format) do
    :io.format(format, row)
  end

  def put_headers(headers, format) do
    headers
    |> map(&to_string/1)
    |> put_one_row(format)
  end

  def put_body(columns, format) do
    columns
    |> List.zip
    |> map(&Tuple.to_list/1)
    |> each(&put_one_row(&1, format))
  end

  def print_table(rows, headers) do
    columns = split_into_columns(rows, headers)
    widths = widths_of(columns, headers)
    format = format_for(widths)
    put_headers(headers, format)
    put_separator(widths)
    put_body(columns, format)
  end

  defp printable(str) when is_binary(str), do: str
  defp printable(str), do: to_string(str)

end