defmodule ElixirGraphQLWeb.AuthToken do
  @moduledoc """
  Creates and verifies authentication tokens.
  """

  @salt "any salt"

  def create(user) do
    Phoenix.Token.sign(ElixirGraphQLWeb.Endpoint, @salt, user.id)
  end

  def verify(token) do
    Phoenix.Token.verify(ElixirGraphQLWeb.Endpoint, @salt, token, max_age: 60 * 60 * 24)
  end
end
