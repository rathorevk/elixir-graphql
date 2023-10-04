defmodule ElixirGraphQLWeb.Schema.AccountsTest do
  use ElixirGraphQLWeb.ConnCase, async: false

  @authenticate_user_mutation """
  mutation authenticateUser($email: String!, $password: String!) {
    authenticateUser(email: $email, password: $password) {
      token
      user {
        email
      }
    }
  }
  """

  describe "mutation: authenticateUser" do
    test "when authentication fails", %{conn: conn} do
      user = ElixirGraphQL.Accounts.create_user!(%{email: "foo@bar.com", password: "password"})

      assert {:error, errors, _} =
               run_graphql(conn, @authenticate_user_mutation, %{
                 email: user.email,
                 password: "foobar"
               })

      assert [%{"message" => "Wrong credentials"}] = errors
    end

    test "when authentication is succesful", %{conn: conn} do
      user = ElixirGraphQL.Accounts.create_user!(%{email: "foo@bar.com", password: "password"})

      assert {:ok, %{"authenticateUser" => response}} =
               run_graphql(conn, @authenticate_user_mutation, %{
                 email: user.email,
                 password: user.password
               })

      assert %{"token" => _, "user" => %{"email" => email}} = response
      assert email == user.email
    end
  end
end
