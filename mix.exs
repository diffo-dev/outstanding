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
      source_url: "https://github.com/diffo-dev/outstanding",
      homepage_url: "https://diffo.dev/diffo/outstanding",
      docs: [main: "readme", extras: ["README.md"]],
      # hex.pm stuff
      description: "Elixir protocol calculating outstanding from expected and actual",
      package: [
        name: "outstanding",
        organization: "diffo_dev",
        licenses: ["MIT"],
        files: ["lib", "mix.exs", "README*", "VERSION*"],
        maintainers: ["Matt Beanland"],
        links: %{
          "GitHub" => "https://github.com/diffo-dev/outstanding",
          "Author's home page" => "https://www.diffo.dev"
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
      {:ex_doc, "~> 0.37", only: :dev, runtime: false}
    ]
  end
end
