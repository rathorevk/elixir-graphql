defmodule ElixirGraphQL.Repo.Migrations.AddUniqueConstraintToVideoLessonsUniqueCode do
  use Ecto.Migration

  def change do
    execute(
      "ALTER TABLE video_lessons ADD CONSTRAINT unique_video_lessons_unique_code UNIQUE (unique_code);"
    )
  end
end
