defmodule ElixirGraphQL.Repo.Migrations.CreateVideoLessons do
  use Ecto.Migration

  def change do
    create table(:video_lessons) do
      add(:unique_code, :string, null: false)
      add(:title, :string, null: false)
      add(:duration, :decimal, null: false)
      add(:video_url, :string, null: false)
    end
  end
end
