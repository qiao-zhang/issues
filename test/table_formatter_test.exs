defmodule TableFormatterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

#  alias Issues.TableFormatter, as: TF

  defp simple_test_data!(rows\\2, widths\\[2, 3, 1]) when rows >= 1 do
    unless Enum.all?(widths, &(&1 >= 1)) do
      raise ArgumentError, message: "All widths should be greater than 0"
    end
    row = for width <- widths, do: String.duplicate("x", width)
    List.duplicate(row, rows)
  end

  test "simple_test_data" do
  assert simple_test_data! ==
    [
      ["xx", "xxx", "x"],
      ["xx", "xxx", "x"],
    ]
  end

  test "split_into_columns" do
    table = simple_test_data!()
    columns = split_into_columns(table)
    assert length(columns) = length(widths)
    assert List.first(columns) == ["xx", "xx"]
    assert List.last(columns) == ["x", "x"]
  end
end