defmodule ElixirGraphQL.Repo.Migrations.AddUniqueConstraintToUsersEmail do
  use Ecto.Migration

  def change do
    execute("ALTER TABLE users ADD CONSTRAINT unique_users_email UNIQUE (email);")
  end
end
