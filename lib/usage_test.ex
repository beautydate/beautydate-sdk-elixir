defmodule BeautyDateAPI.UsageTest do
  import BeautyDateAPI

  def fetch_by_url do
    fetch(request(endpoint: "businesses", type: "business"))
  end

  def fetch_composing do
    request(endpoint: "businesses", type: "business")
    |> id(4)
    |> fetch
  end

  def fetch_list do
    user_token = "token"

    request(endpoint: "businesses", type: "business")
    |> fields(businesses: "name,description,website", reviews: "comment,rating", address: "state")
    |> include([:reviews, :address])
    |> sort("id,-name")
    |> page(size: 10, page: 1)
    |> filter(name: "Maria Estética")
    |> params(custom1: 1, custom2: 2)
    |> header("X-BeautyDate-Session-Token": "Token=\"#{user_token}\"")
    |> header("X-BeautyDate-Gender": "male")
    |> fetch
  end

  def update_resource do
    request(endpoint: "businesses", type: "business")
    |> id(4)
    |> resource(%BeautyDateAPI.Resource{
      type: "business",
      id: 4,
      attributes: %{website: "http://foo.bar/"}
    })
    |> update
  end

  def create_resource do
    new_business_payment = %BeautyDateAPI.Resource{
      type: "busines_payments",
      attributes: %{
        name: "Barba Negra",
        cpf_cnpj: "53357810921",
        email: "tiagopog@gmail.com",
        business_id: "5173956d-0344-4220-9fd0-154200292fd5",
        street: "Rua Carmelo Rangel",
        city: "Curitiba",
        state: "PR",
        neighborhood: "Centro",
        street_number: 254,
        zipcode: "81160-532"
      }
    }

    request(endpoint: "business-payments/subscribe", type: "business_payments")
    |> resource(new_business_payment)
    |> create
  end

  def delete_resource do
    request(endpoint: "businesses", type: "business")
    |> id(3)
    |> delete
  end
end
