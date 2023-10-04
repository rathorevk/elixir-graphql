import Config

config :elixir_graphql, ElixirGraphQL.Repo,
  username: "postgres",
  password: "postgres",
  database: "ElixirGraphQL_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :elixir_graphql, ElixirGraphQLWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "O808h1gborhygw/1POu3T0Wpnt2sL7c08jMe4FpHmIx1d0c437B9hqV2Im3XBI2P",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
