import Config

config :elixir_graphql, ecto_repos: [ElixirGraphQL.Repo]

# Configures the endpoint
config :elixir_graphql, ElixirGraphQLWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: ElixirGraphQLWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: ElixirGraphQL.PubSub,
  live_view: [signing_salt: "AWLG/V0P"]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
