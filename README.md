# Elixir Beauty Date API SDK

The official Beauty Date API client package for Elixir.

## Installation [WIP]

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `beautydate_api` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:beautydate_api, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/beautydate_api](https://hexdocs.pm/beautydate_api).

## Usage

First, import `BeautyDateAPI` inside your module to gain access to its functions:
```elixir
import BeautyDateAPI
```

Then a set of functions will be available for you to query and interact with the exteral API:

**Fetch by URL**
```elixir
fetch(request(endpoint: "businesses", type: "business"))
```

**Fetch by composing query**
```elixir
# Eg.: 1, Small Queries.

request(endpoint: "businesses", type: "business")
|> id(4)
|> fetch
```

```elixir
# Eg. 2, Big Queries.

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
```

**Update resource**
```elixir
request(endpoint: "businesses", type: "business")
|> id(4)
|> resource(%BeautyDateAPI.Resource{
     type: "business",
     id: 4,
     attributes: %{website: "http://foo.bar/"}
   })
|> update
```

**Create resource**
```elixir
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
```

**Delete resource**
```elixir
request(endpoint: "businesses", type: "business")
|> id(3)
|> delete
```
