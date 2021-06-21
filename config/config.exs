# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :chatter,
  ecto_repos: [Chatter.Repo]

# Configures the endpoint
config :chatter, ChatterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "FAyCaOo2NuYf/BbDwRHnnD6M+GNCe7IoFwQFvknBLP7dP0b/4TwuL4v7zYtUmVNF",
  render_errors: [view: ChatterWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Chatter.PubSub,
  live_view: [signing_salt: "VFoxze64"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# Configures Guardian
# config :chatter, Chatter.Accounts.Guardian,
#        issuer: "chatter",
#        secret_key: "tu54Q9Jh6IYrq25ByRHUoP9Bs4XrlZvm"

