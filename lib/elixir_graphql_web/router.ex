defmodule ElixirGraphQLWeb.Router do
  @moduledoc """
  ElixirGraphQLWeb's router.
  """

  use ElixirGraphQLWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])

    plug(ElixirGraphQLWeb.Plugs.SetCurrentUser)
  end

  scope "/" do
    pipe_through(:api)

    forward("/api", Absinthe.Plug,
      schema: ElixirGraphQLWeb.Schema,
      json_codec: Jason,
      interface: :simple
    )

    forward("/graphiql", Absinthe.Plug.GraphiQL,
      schema: ElixirGraphQLWeb.Schema,
      context: %{pubsub: ElixirGraphQL.Endpoint}
    )
  end
end
