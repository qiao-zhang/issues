defmodule CLITest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [parse_args: 1,
                            sort_into_ascending_order: 1]

  test ":help returned when giving -h or --help" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "count is defaulted if two values given" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end

  test "sort ascending orders correctly" do
    sorted_issues =
      ["c", "a", "d", "b"] |>
        fake_issue_list |>
        sort_into_ascending_order
    dates = for issue <- sorted_issues, do: Map.get(issue, "created_at")
    assert dates == ["a", "b", "c", "d"]
  end
  
  defp fake_issue_list(dates) do
    for date <- dates,
    do: %{"created_at" => date}
  end
end