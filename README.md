# Elixir Beauty Date API SDK

The official Beauty Date API client package for Elixir. It uses [HTTPoison](https://github.com/edgurgel/httpoison) to deal with HTTP, implements all the [JSON API](http://jsonapi.org/) standards and was built specially for the [BeautyDate API V2](https://beautydate.com.br/api/v2/docs/businesses).

The "pipe operator oriented" query syntax was inspired by Decisiv's [json_api_client](https://github.com/Decisiv/json_api_client) package. But it's a completely different implementation.

## Installation

```elixir
def deps do
  [
    {:beautydate_api, git: "https://github.com/b2beauty/beautydate-sdk-elixir.git"}
  ]
end
```

## Configuration

Add to your `config/config.exs`:

```elixir
config :beautydate_api,
  b2b_api_url: "https://beautydate.com.br/",
  b2b_api_consumer_token: "your_token_here",
  agent: "web",
  agent_version: "0.1.0"
```

### Environment-Based Configuration

You can use different files for different environments. Eg.:

`config/dev.exs`
```elixir
config :beautydate_api,
  b2b_api_url: "http://localhost:3000/api/v2/",
  b2b_api_consumer_token: "your_development_token_here",
```

`config/prod.exs`
```elixir
config :beautydate_api,
  b2b_api_url: "https://beautydate.com.br/",
  b2b_api_consumer_token: "your_production_token_here",
```

`config/config.exs`
```elixir
import_config "#{Mix.env()}.exs"

config :beautydate_api,
  agent: "web",
  agent_version: "0.1.0"
```

This also allows for a `config/test.exs` config file.

## Usage

First, import `BeautyDateAPI` inside your module to gain direct access to its functions:
```elixir
import BeautyDateAPI
```

Then a set of functions will be top-level available for you to query and interact with the external API:

### Fetch by URL
```elixir
fetch(request(endpoint: "businesses", type: "business"))
```

### Fetch by composing query
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

### Update resource
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

### Create resource
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

### Delete resource
```elixir
request(endpoint: "businesses", type: "business")
|> id(3)
|> delete
```

## Tip About Namespaces

The `BeautyDateAPI` module has many functions, when imported via `import` it may conflict with your local top-leveled ones. To overcome it, it's recommended that you either use its full namespace reference, like: `BeautyDateAPI.request/1`, `BeautyDateAPI.id/2`, `BeautyDateAPI.delete/1` and so on. Or you can set up a short alias to better help typing your queries. Eg.:

```Elixir
alias BeautyDateAPI, as: B2

B2.request(endpoint: "businesses", type: "business")
|> B2.id(4)
|> B2.fetch
```

## To Do
- [ ] Testing.
- [ ] Typespecs.
- [ ] Documentation.
- [ ] Finish README; Add responses.
- [x] Fix Environment variables.
- [ ] Publish Hex package. *This will wait.*

