defmodule Issues.GithubIssues do

  require Logger

  @user_agent [{"User-agent", "Elixir qiao.zhang.2015@gmail.com"}]
  @github_url Application.get_env(:issues, :github_url)
  
  def fetch(user, project) do
    Logger.info "Fetching user #{user}'s project #{project}'"
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  defp issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    Logger.info "Successful response"
    Logger.debug fn -> inspect(body) end
    {:ok, Poison.Parser.parse!(body)}
  end
  defp handle_response({_, %{status_code: status, body: body}}) do
    Logger.error fn -> "Error #{status} returned" end
    {:error, Poison.Parser.parse!(body)}
  end

end