defmodule BeautyDateAPI.MixProject do
  use Mix.Project

  def project do
    [
      app: :beautydate_api,
      version: "0.1.0",
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "BeautyDateAPI",
      source_url: "https://github.com/b2beauty/beautydate-sdk-elixir/"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.1"},
      {:httpoison, "~> 1.0"},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Fernando Schuindt", "Tiago Guedes"],
      links: %{"GitHub" => "https://github.com/b2beauty/beautydate-sdk-elixir/"}
    ]
  end

  defp description do
    """
      The official Beauty Date API client package for Elixir.
    """
  end
end
