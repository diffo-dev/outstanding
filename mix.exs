defmodule Outstanding.MixProject do
  use Mix.Project

  def project do
    [
      app: :outstanding,
      version: "0.1.0",
      elixir: "~> 1.18",
      consolidate_protocols: Mix.env() != :test,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # ex_doc
      name: "Outstanding",
      source_url: "https://github.com/matt-beanland/outstanding",
      homepage_url: "https://diffo.dev/diffo/outstanding",
      docs: [main: "readme", extras: ["README.md"]],
      # hex.pm stuff
      description: "Outstanding (a.k.a extent expected realised by actual) Elixir protocol",
      package: [
        licenses: ["MIT"],
        files: ["lib", "mix.exs", "README*", "VERSION*"],
        maintainers: ["Matt Beanland"],
        links: %{
          "GitHub" => "https://github.com/matt-beanland/outstanding",
          "Author's home page" => "https://diffo.dev"
        }
      ]
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
      {:typable, "~> 0.3"},
      {:ex_doc, "~> 0.37"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
