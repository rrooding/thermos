defmodule Thermos.Thermostat.Mixfile do
  use Mix.Project

  def project do
    [app: :thermostat,
     version: "0.0.4",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :instream, :open_weathermap, :sensors],
     mod: {Thermos.Thermostat, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # To depend on another app inside the umbrella:
  #
  #   {:myapp, in_umbrella: true}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:instream, "~> 0.13"},
     {:open_weathermap, in_umbrella: true},
     {:sensors, in_umbrella: true},
     {:utils, in_umbrella: true}]
  end
end
