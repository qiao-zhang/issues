defmodule Issues.TableFormatter do
  @moduledoc false
  def split_into_columns(rows, headers) do
    for header <- headers do
      for row <- rows, do: row[header] |> printable
    end
  end

  defp printable(str) when is_binary(str), do: str
  defp printable(str), do: to_string(str)
end