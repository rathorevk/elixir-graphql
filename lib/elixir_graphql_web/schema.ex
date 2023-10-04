defmodule ElixirGraphQLWeb.Schema do
  @moduledoc """
  The GraphQL API schema for GraphQL Queries and Mutations.
  """

  use Absinthe.Schema

  import_types(ElixirGraphQLWeb.Schema.Accounts)
  import_types(ElixirGraphQLWeb.Schema.Content)
  import_types(ElixirGraphQLWeb.Schema.UserProgress)

  query do
    import_fields(:content_queries)
    import_fields(:user_progress_queries)
  end

  mutation do
    import_fields(:accounts_mutations)
  end
end
