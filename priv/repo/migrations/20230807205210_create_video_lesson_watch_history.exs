defmodule ElixirGraphQL.Repo.Migrations.CreateVideoLessonWatchHistory do
  use Ecto.Migration

  def change do
    create table(:video_lesson_watch_history) do
      add(:video_lesson_id, references(:video_lessons), null: false)
      add(:user_id, references(:users), null: false)
      add(:watched_at, :utc_datetime, null: false)
      add(:duration_watched, :decimal, null: false)
    end
  end
end
