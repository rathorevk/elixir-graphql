defmodule ElixirGraphQL.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :elixir_graphql,
    adapter: Ecto.Adapters.Postgres
end
