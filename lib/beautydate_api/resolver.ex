defmodule BeautyDateAPI.Resolver do
  def resolve([entity]), do: entity

  def resolve([entity | params]) when length(params) == 1 do
    entity <> resolve(hd(params))
  end

  def resolve([entity | params]) do
    [entity, resolve(hd(params)), tl(params) |> Enum.join("&")]
    |> Enum.join()
  end

  def resolve(param) when is_integer(param), do: "/#{param}?"

  def resolve(param), do: "?#{param}&"
end
