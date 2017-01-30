defmodule TableFormatterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Issues.TableFormatter, as: TF

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
    rows = simple_test_data!(2, headers, [2, 3, 1])
    columns = TF.split_into_columns(rows, headers)
    assert length(columns) == length(headers)
    assert List.first(columns) == ["xx", "xx"]
    assert List.last(columns) == ["x", "x"]
  end

  test "get table widths correctly" do
    headers = [:header1, :h2, :hdr3]
    rows = simple_test_data!(1, headers, [2, 4, 5])
    columns = TF.split_into_columns(rows, headers)
    widths = TF.widths_of(columns, headers)
    assert widths == [7, 4, 5]
  end

  test "get format correctly" do
    assert TF.format_for([3, 7, 8, 2]) == "~-3s | ~-7s | ~-8s | ~-2s~n"
    assert TF.format_for([5, 4, 3]) == "~-5s | ~-4s | ~-3s~n"
  end

  test "put separator correctly" do
    output = capture_io fn ->
      TF.put_separator([2, 3, 4])
    end
    assert output == "---+-----+-----\n"
  end

  test "put header correctly" do
    output1 = capture_io fn ->
      TF.put_one_row([:h1, :hd2, :header3], "~-2s | ~-3s | ~-7s~n")
    end
    assert output1 == "h1 | hd2 | header3\n"

    output2 = capture_io fn ->
      TF.put_one_row([:h1, :hd2, :h3], "~-3s | ~-4s | ~-4s~n")
    end
    assert output2 == "h1  | hd2  | h3  \n"
  end

  test "print table correctly" do
    headers = [:h1, :hd2, :header3, :h4]
    rows = simple_test_data!(3, headers, [3, 2, 4, 1])
    output = capture_io fn ->
      TF.print_table(rows, headers)
    end
    assert output = """
    h1  | hd2 | header3 | h4
    ----+-----+---------+---
    xxx | xx  | xxxx    | x
    xxx | xx  | xxxx    | x
    xxx | xx  | xxxx    | x
    """
  end
end