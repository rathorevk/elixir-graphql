defmodule ElixirGraphQL.Accounts do
  @moduledoc """
  The Accounts context.

  Functions related to user's authentication and authorization.
  """

  alias ElixirGraphQL.Repo
  alias ElixirGraphQL.Accounts.User
  require Crudry.Context

  Crudry.Context.generate_functions(User)

  def authenticate_user(email, password) do
    user = get_user_by(email: email)

    if user.password == password do
      token = ElixirGraphQLWeb.AuthToken.create(user)
      {:ok, %{user: user, token: token}}
    else
      {:error, :wrong_credentials}
    end
  end
end
