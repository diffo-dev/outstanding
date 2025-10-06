defmodule Outstanding.MixProject do
  use Mix.Project

  @name :outstanding
  @version "0.2.4"
  @description "Elixir protocol calculating outstanding from expected and actual"
  @github_url "https://github.com/diffo-dev/outstanding"

  def project() do
    [
      app: @name,
      version: @version,
      name: @name,
      description: @description,
      elixir: "~> 1.18",
      consolidate_protocols: Mix.env() != :test,
      start_permanent: Mix.env() == :prod,
      package: package(),
      # ex_doc
      source_url: @github_url,
      homepage_url: "https://diffo.dev/diffo/outstanding",
      elixirc_paths: elixirc_paths(Mix.env()),
      # hex.pm stuff
      deps: deps(),
      docs: &docs/0
    ]
  end

  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      name: @name,
      licenses: ["MIT"],
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*
      CHANGELOG*),
      links: %{
        "GitHub" => @github_url,
        "Author's home page" => "https://www.diffo.dev"
      }
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
      {:ex_doc, "~> 0.37", only: :dev, runtime: false},
      {:ex_check, "~> 0.12", only: [:dev, :test]},
      {:git_ops, "~> 2.7", only: [:dev], runtime: false},
      {:credo, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, ">= 0.0.0", only: [:dev, :test], runtime: false}
    ]
  end

  def docs() do
    [
      homepage_url: @github_url,
      source_url: @github_url,
      source_ref: "v#{@version}",
      main: "readme",
      logo: "logos/diffo.jpg",
      extras: [
        "README.md": [title: "Guide"],
        "LICENSE.md": [title: "License"]
      ]
    ]
  end
end
