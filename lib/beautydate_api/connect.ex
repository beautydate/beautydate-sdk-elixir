defmodule BeautyDateAPI.Connect do
  def connect(call, endpoint, headers, resource) do
    endpoint
    |> resolve_and_encode
    |> call.(resource |> Poison.encode!(), headers, [])
  end

  def connect(call, endpoint, headers) do
    endpoint
    |> resolve_and_encode
    |> call.(headers, [])
  end

  defp resolve_and_encode(endpoint) do
    endpoint
    |> BeautyDateAPI.Resolver.resolve()
    |> URI.encode()
  end
end
