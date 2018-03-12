defmodule BeautyDateAPI.HTTP do
  use HTTPoison.Base

  def process_url(url) do
    get_env(:b2b_api_url) <> url
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
  end

  defp process_request_headers(headers) do
    headers ++
      [
        Accept: "Application/json; Charset=utf-8",
        Authorization: "Bearer #{get_env(:b2b_api_consumer_token)}",
        "Content-Type": "application/vnd.api+json",
        "X-BeautyDate-Agent": get_env(:agent),
        "X-BeautyDate-Agent-Version": get_env(:agent_version)
      ]
  end

  defp get_env(key), do: Application.get_env(:beautydate_api, key)
end
