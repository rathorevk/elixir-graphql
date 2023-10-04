defmodule ElixirGraphQL.AccountsTest do
  use ElixirGraphQL.RepoCase
  alias ElixirGraphQL.Accounts

  describe "User.changeset/2" do
    test "validates required fields" do
      {:error, changeset} = Accounts.create_user(%{})
      errors = errors_on(changeset)
      assert errors.email == ["can't be blank"]
      assert errors.password == ["can't be blank"]
    end

    test "email has correct format" do
      {:error, changeset} = Accounts.create_user(%{email: "not an email", password: "123456"})
      errors = errors_on(changeset)
      assert errors.email == ["has invalid format"]
    end

    test "email must be unique" do
      {:ok, _user} = Accounts.create_user(%{email: "foo@bar.com", password: "123456"})

      {:error, changeset} = Accounts.create_user(%{email: "foo@bar.com", password: "123456"})

      errors = errors_on(changeset)
      assert errors.email == ["has already been taken"]
    end
  end

  describe "authenticate_user/2" do
    test "returns user and token when credentials are valid" do
      {:ok, user} = Accounts.create_user(%{email: "foo@bar.com", password: "password"})

      assert {:ok, %{user: returned_user, token: _}} =
               Accounts.authenticate_user(user.email, user.password)

      assert returned_user.email == user.email
    end

    test "returns error when credentials are invalid" do
      {:ok, user} = Accounts.create_user(%{email: "foo@bar.com", password: "password"})

      assert {:error, :wrong_credentials} = Accounts.authenticate_user(user.email, "foobar")
    end
  end
end
