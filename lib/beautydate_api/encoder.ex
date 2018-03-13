defmodule BeautyDateAPI.Encoder do
  @moduledoc """
  A mix of JSON API and URI enconder. Acts like a helper for the
  URI parameters generation.
  """

  @doc ~S"""
  URI encode a list of resources or a single one. Follows the JSON
  API standard for includes.

  ## Examples

      iex> BeautyDateAPI.Encoder.encode_includes([:reviews, :address])
      "include=reviews,address"
      
      iex> BeautyDateAPI.Encoder.encode_includes(:address)
      "include=address"
  """
  @spec encode_includes(includes) :: String.t when includes: atom
  @spec encode_includes(includes) :: String.t when includes: list(atom)
  @spec encode_includes(includes) :: String.t when includes: String.t
  def encode_includes(includes) do
    "include=" <> ([includes] |> List.flatten() |> Enum.join(","))
  end

  @doc ~S"""
  URI encode a string of comma separated resources or a single one.
  Follows the JSON API standard for sorting.

  ## Examples

      iex> BeautyDateAPI.Encoder.encode_sort("id,-name")
      "sort=id,-name"
  """
  @spec encode_sort(String.t) :: String.t
  def encode_sort(fields) do
    "sort=#{fields}"
  end

  @doc ~S"""
  URI encode a predefined keyword list of pagination parameters.
  Follows the JSON API standard for pagination.

  ## Examples

      iex> BeautyDateAPI.Encoder.encode_page(size: 10, page: 1)
      "page[number]=1&page[size]=10"
  """
  @spec encode_page(keyword) :: String.t
  def encode_page(pagination) do
    "page[number]=#{pagination[:page]}&page[size]=#{pagination[:size]}"
  end

  @doc ~S"""
  URI encode a name and a keyword list, following the JSON API
  convention for different fields for different resources. It's a
  general purpose JSON API URI parameters encoder.

  ## Examples

      iex> BeautyDateAPI.Encoder.encode_jsonapi("fields", reviews: "comment,rating", address: "state")
      "fields[reviews]=comment,rating&fields[address]=state"
  """
  @spec encode_jsonapi(String.t, keyword) :: String.t
  def encode_jsonapi(name, fields) do
    fields
    |> Enum.map(fn {key, value} -> "#{name}[#{key}]=#{value}" end)
    |> Enum.join("&")
  end
end
