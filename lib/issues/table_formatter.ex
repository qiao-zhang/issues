defmodule Issues.TableFormatter do
  import Enum, only: [ zip: 2, map: 2, max: 1 ]
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

  defp printable(str) when is_binary(str), do: str
  defp printable(str), do: to_string(str)

end