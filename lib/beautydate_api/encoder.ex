defmodule BeautyDateAPI.Encoder do
  def encode_includes(includes) do
    "include=" <> ([includes] |> List.flatten() |> Enum.join(","))
  end

  def encode_sort(fields) do
    "sort=#{fields}"
  end

  def encode_page(pagination) do
    "page[number]=#{pagination[:page]}&page[size]=#{pagination[:size]}"
  end

  def encode_jsonapi(name, fields) do
    fields
    |> Enum.map(fn {key, value} -> "#{name}[#{key}]=#{value}" end)
    |> Enum.join("&")
  end
end
