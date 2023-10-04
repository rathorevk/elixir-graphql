defmodule ElixirGraphQL.Accounts.User do
  @moduledoc """
  Represents a user of the application.
  """

  use TypedEctoSchema

  import Ecto.Changeset

  typed_schema "users" do
    field(:email, :string)
    field(:password, :string)
  end

  @required ~w[email password]a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email, name: :unique_users_email)
  end
end
