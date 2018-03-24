defmodule BeautyDateAPI.ResponseErrorParser do
  def parse(response) do
    {:ok, response, response.status_code}
    |> parse_errors_if_any()
  end

  defp parse_errors_if_any({:ok, response, 200}), do: response

  defp parse_errors_if_any({:ok, response, _status}) do
    hd(response.body["errors"])
    |> write_error_msg()
  end

  defp write_error_msg(error) do
    """
    HTTP Status: #{error["status"]}
    API Error Code: #{error["code"]}
    Error Title: #{error["title"]}
    Detail: #{error["detail"]}
    """
  end
end
