defmodule Issues.GithubIssues do
  @moduledoc false

  @user_agent [{"User-agent", "Elixir qiao.zhang.2015@gmail.com"}]
  @github_url Application.get_env(:issues, :github_url)
  
  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, Poison.parser.parse!(body)}
  end
  def handle_response({_, %{body: body}}) do
    {:error, Poison.parser.parse!(body)}
  end

end