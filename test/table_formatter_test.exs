defmodule TableFormatterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

#  alias Issues.TableFormatter, as: TF

  defp simple_test_data!(rows, headers, widths) when rows >= 1 do
    unless length(headers) == length(widths) do
      raise ArgumentError,
            message: "Number of headers and number of widths unmatch"
    end
    row = for {h, w} <- Enum.zip(headers, widths) do
            {h, String.duplicate("x", w)}
          end
    List.duplicate(row, rows)
  end

  test "simple_test_data" do
  assert simple_test_data!(2, [:h1, :hd2, :header3], [2, 3, 1]) ==
    [
      [h1: "xx", hd2: "xxx", header3: "x"],
      [h1: "xx", hd2: "xxx", header3: "x"],
    ]
  end

  test "split_into_columns" do
    headers = [:h1, :hd2, :header3]
    table = simple_test_data!(2, headers, [2, 3, 1])
    columns = split_into_columns(table, headers)
    assert length(columns) = length(headers)
    assert List.first(columns) == ["xx", "xx"]
    assert List.last(columns) == ["x", "x"]
  end
end