defmodule BeautyDateAPI do
  import BeautyDateAPI.Encoder
  import BeautyDateAPI.Connect

  def request(endpoint: endpoint, type: type) do
    [
      endpoint: [endpoint],
      resource: %BeautyDateAPI.Resource{type: type},
      headers: []
    ]
  end

  def fields([endpoint: endpoint, resource: resource, headers: headers], fields) do
    [
      endpoint: endpoint ++ [encode_jsonapi("fields", fields)],
      resource: resource,
      headers: headers
    ]
  end

  def include([endpoint: endpoint, resource: resource, headers: headers], includes) do
    [
      endpoint: endpoint ++ [encode_includes(includes)],
      resource: resource,
      headers: headers
    ]
  end

  def sort([endpoint: endpoint, resource: resource, headers: headers], fields) do
    [
      endpoint: endpoint ++ [encode_sort(fields)],
      resource: resource,
      headers: headers
    ]
  end

  def page([endpoint: endpoint, resource: resource, headers: headers], pagination) do
    [
      endpoint: endpoint ++ [encode_page(pagination)],
      resource: resource,
      headers: headers
    ]
  end

  def filter([endpoint: endpoint, resource: resource, headers: headers], filters) do
    [
      endpoint: endpoint ++ [encode_jsonapi("filter", filters)],
      resource: resource,
      headers: headers
    ]
  end

  def params([endpoint: endpoint, resource: resource, headers: headers], params) do
    [
      endpoint: endpoint ++ [URI.encode_query(params)],
      resource: resource,
      headers: headers
    ]
  end

  def id([endpoint: endpoint, resource: resource, headers: headers], id) do
    [
      endpoint: endpoint ++ [id],
      resource: resource,
      headers: headers
    ]
  end

  def header([endpoint: endpoint, resource: resource, headers: headers], new_header) do
    [
      endpoint: endpoint,
      resource: resource,
      headers: headers ++ new_header
    ]
  end

  def resource([endpoint: endpoint, resource: _r, headers: headers], resource) do
    [
      endpoint: endpoint,
      resource: resource,
      headers: headers
    ]
  end

  def fetch(endpoint: endpoint, resource: _r, headers: headers) do
    connect(&BeautyDateAPI.HTTP.get/3, endpoint, headers)
  end

  def delete(endpoint: endpoint, resource: _r, headers: headers) do
    connect(&BeautyDateAPI.HTTP.delete/3, endpoint, headers)
  end

  def create(endpoint: endpoint, resource: resource, headers: headers) do
    connect(&BeautyDateAPI.HTTP.post/4, endpoint, headers, resource)
  end

  def update(endpoint: endpoint, resource: resource, headers: headers) do
    connect(&BeautyDateAPI.HTTP.put/4, endpoint, headers, resource)
  end
end
