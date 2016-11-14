# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :web,
  namespace: Thermos.Web

# Configures the endpoint
config :web, Thermos.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "taM6LxvNZ0lAbZbeh9zDgcbAc31m3vpqZI1AJuy7J7jAoGc9Xd2JCcsUb1pYUboC",
  render_errors: [view: Thermos.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: Thermos.Web.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
