defmodule ElixirGraphQLWeb.Schema.Accounts do
  @moduledoc """
  The GraphQL API schema for the Accounts context.
  """

  use Absinthe.Schema.Notation

  alias ElixirGraphQL.Accounts

  object :user do
    field(:email, non_null(:string))
  end

  object :session do
    field(:user, non_null(:user))
    field(:token, non_null(:string))
  end

  object :accounts_mutations do
    field :authenticate_user, :session do
      arg(:email, :string)
      arg(:password, :string)

      resolve(fn %{email: email, password: password}, _context ->
        case Accounts.authenticate_user(email, password) do
          {:ok, %{user: user, token: token}} ->
            {:ok, %{token: token, user: %{email: user.email}}}

          {:error, :wrong_credentials} ->
            {:error, message: "Wrong credentials"}
        end
      end)
    end
  end
end
