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

### Responses

The API responses comes in the following format:
```elixir
# When something goes wrong during the HTTP connection.
{:error, reason}

# When everything is ok with the HTTP connection.
{ok, response}
```

Here's a successful response sample from a fetch:
```elixir
{:ok,
 %HTTPoison.Response{
   body: %{
     "data" => [
       %{
         "attributes" => %{
           "description" => "",
           "name" => "Maria Estética",
           "website" => "http://lalalala.com.br"
         },
         "id" => "3",
         "links" => %{"self" => "http://localhost:3000/api/v2/businesses/3"},
         "type" => "businesses"
       }
     ],
     "included" => [
       %{
         "attributes" => %{
           "address_type" => "work",
           "addressable_id" => 3,
           "addressable_type" => "Business",
           "city" => "Cidade Aleatória",
           "complement" => "Apto. 999",
           "country" => "BR",
           "created_at" => "2018-03-08T17:40:25.949-03:00",
           "neighborhood" => "Algum Lugar",
           "state" => "PA",
           "street" => "Alguma Rua",
           "street_number" => "NUMERO",
           "updated_at" => "2018-03-08T17:40:25.949-03:00",
           "zipcode" => "99999999"
         },
         "id" => "39",
         "links" => %{"self" => "http://localhost:3000/api/v2/addresses/39"},
         "relationships" => %{
           "addressable" => %{
             "data" => %{"id" => "3", "type" => "businesses"},
             "links" => %{
               "related" => "http://localhost:3000/api/v2/addresses/39/addressable",
               "self" => "http://localhost:3000/api/v2/addresses/39/relationships/addressable"
             }
           }
         },
         "type" => "addresses"
       }
     ],
     "links" => %{
       "first" => "http://localhost:3000/api/v2/businesses?fields%5Baddress%5D=state&fields%5Bbusinesses%5D=name%2Cdescription%2Cwebsite&fields%5Breviews%5D=comment%2Crating&filter%5Bname%5D=Maria+Est%C3%A9tica&include=reviews%2Caddress&page%5Bnumber%5D=1&page%5Bsize%5D=10&sort=id%2C-name",
       "last" => "http://localhost:3000/api/v2/businesses?fields%5Baddress%5D=state&fields%5Bbusinesses%5D=name%2Cdescription%2Cwebsite&fields%5Breviews%5D=comment%2Crating&filter%5Bname%5D=Maria+Est%C3%A9tica&include=reviews%2Caddress&page%5Bnumber%5D=1&page%5Bsize%5D=10&sort=id%2C-name"
     },
     "meta" => %{"record_count" => 1}
   },
   headers: [
     {"X-Frame-Options", "SAMEORIGIN"},
     {"X-XSS-Protection", "1; mode=block"},
     {"X-Content-Type-Options", "nosniff"},
     {"Access-Control-Allow-Origin", "*"},
     {"Access-Control-Allow-Methods",
      "GET, PUT, POST, PATCH, DELETE, OPTIONS, HEAD"},
     {"Access-Control-Request-Method", "GET, POST, OPTIONS"},
     {"Access-Control-Allow-Headers",
      "*,x-requested-with,Content-Type,If-Modified-Since,If-None-Match"},
     {"Access-Control-Max-Age", "0"},
     {"Content-Type", "application/vnd.api+json"},
     {"Vary", "Accept-Encoding, Origin"},
     {"ETag", "W/\"2589f9edaaf1f2815e4edab7a17710e9\""},
     {"Cache-Control", "max-age=0, private, must-revalidate"},
     {"X-Meta-Request-Version", "0.3.4"},
     {"X-Request-Id", "08c32e41-0a89-4cbc-b52a-2c34d86258d8"},
     {"X-Runtime", "0.722823"},
     {"X-Rack-CORS", "preflight-hit; no-origin"},
     {"Transfer-Encoding", "chunked"}
   ],
   request_url: "http://localhost:3000/api/v2/businesses?fields[businesses]=name,description,website&fields[reviews]=comment,rating&fields[address]=state&include=reviews,address&sort=id,-name&page[number]=1&page[size]=10&filter[name]=Maria%20Est%C3%A9tica&custom1=1&custom2=2",
   status_code: 200
 }}
```

And here's a failing HTTP request response. In this case for a unknown domain name:
```elixir
{:error, %HTTPoison.Error{id: nil, reason: :nxdomain}}
```

**Warning**

Note those are errors related with the HTTP. But during API related errors it stills returns a `{:ok, response}` tuple, because the HTTP request was indeed successful. API errors lay inside the response. Eg.:

```elixir
{:ok,
 %HTTPoison.Response{
   body: %{
     "errors" => [
       %{
         "code" => 127,
         "detail" => "Please, check the user's token (token)",
         "href" => nil,
         "id" => nil,
         "links" => nil,
         "meta" => nil,
         "source" => nil,
         "status" => "401",
         "title" => "Invalid user token"
       }
     ]
   },
   headers: [
     {"X-Frame-Options", "SAMEORIGIN"},
     {"X-XSS-Protection", "1; mode=block"},
     {"X-Content-Type-Options", "nosniff"},
     {"Access-Control-Allow-Origin", "*"},
     {"Access-Control-Allow-Methods",
      "GET, PUT, POST, PATCH, DELETE, OPTIONS, HEAD"},
     {"Access-Control-Request-Method", "GET, POST, OPTIONS"},
     {"Access-Control-Allow-Headers",
      "*,x-requested-with,Content-Type,If-Modified-Since,If-None-Match"},
     {"Access-Control-Max-Age", "0"},
     {"Content-Type", "application/json; charset=utf-8"},
     {"Vary", "Accept-Encoding, Origin"},
     {"Cache-Control", "no-cache"},
     {"X-Meta-Request-Version", "0.3.4"},
     {"X-Request-Id", "1db62141-5604-4618-a301-4c812d8ae90f"},
     {"X-Runtime", "0.789499"},
     {"X-Rack-CORS", "preflight-hit; no-origin"},
     {"Transfer-Encoding", "chunked"}
   ],
   request_url: "http://localhost:3000/api/v2/businesses?fields[businesses]=name,description,website&fields[reviews]=comment,rating&fields[address]=state&include=reviews,address&sort=id,-name&page[number]=1&page[size]=10&filter[name]=Maria%20Est%C3%A9tica&custom1=1&custom2=2",
   status_code: 401
 }}
```

Check the [HTTPoison](https://github.com/edgurgel/httpoison) [documentation](https://hexdocs.pm/httpoison/) for a better understanding of its responses.

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
- [x] Finish README; Add responses.
- [x] Fix Environment variables.
- [ ] Publish Hex package. *This will wait.*
- [x] Fix the `/` requirement in Config URL.

