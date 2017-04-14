# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :social_presence, SocialPresence.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mCxETM8nVd6cAnjDJGFnW/YmD63qfv6MYC2qAlk1o3cNVH5uBRTIavXUxRtc594y",
  render_errors: [view: SocialPresence.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SocialPresence.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
