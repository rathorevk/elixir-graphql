defmodule ElixirGraphQL.UserProgressTest do
  use ElixirGraphQL.RepoCase
  alias ElixirGraphQL.{UserProgress, Content}

  describe "VideoLessonWatchHistory.changeset/2" do
    test "validates required fields" do
      {:error, changeset} = UserProgress.create_video_lesson_watch_history(%{})

      errors = errors_on(changeset)
      assert errors.video_lesson_id == ["can't be blank"]
      assert errors.user_id == ["can't be blank"]
      assert errors.watched_at == ["can't be blank"]
      assert errors.duration_watched == ["can't be blank"]
    end

    test "video lesson must exist" do
      {:error, changeset} =
        UserProgress.create_video_lesson_watch_history(%{
          video_lesson_id: 1,
          user_id: 1,
          watched_at: DateTime.utc_now(),
          duration_watched: 10
        })

      errors = errors_on(changeset)
      assert errors.video_lesson == ["does not exist"]
    end

    test "user must exist" do
      {:ok, video_lesson} =
        Content.create_video_lesson(%{
          unique_code: "algebra",
          title: "Algebra",
          duration: 10,
          video_url: "url"
        })

      {:error, changeset} =
        UserProgress.create_video_lesson_watch_history(%{
          video_lesson_id: video_lesson.id,
          user_id: 1,
          watched_at: DateTime.utc_now(),
          duration_watched: 10
        })

      errors = errors_on(changeset)
      assert errors.user == ["does not exist"]
    end
  end
end
