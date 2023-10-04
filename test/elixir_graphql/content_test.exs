defmodule ElixirGraphQL.ContentTest do
  alias ElixirGraphQL.UserProgress
  use ElixirGraphQL.RepoCase
  alias ElixirGraphQL.{Content, Accounts, UserProgress}

  describe "VideoLesson.changeset/2" do
    test "validates required fields" do
      {:error, changeset} = Content.create_video_lesson(%{})

      errors = errors_on(changeset)
      assert errors.unique_code == ["can't be blank"]
      assert errors.title == ["can't be blank"]
      assert errors.duration == ["can't be blank"]
      assert errors.video_url == ["can't be blank"]
    end

    test "unique_code must be unique ;)" do
      attrs = %{unique_code: "algebra", title: "Algebra", duration: 10, video_url: "url"}
      {:ok, _user} = Content.create_video_lesson(attrs)

      {:error, changeset} = Content.create_video_lesson(attrs)

      errors = errors_on(changeset)
      assert errors.unique_code == ["has already been taken"]
    end
  end

  describe "get_next_video_lesson_for/1" do
    setup do
      user = Accounts.create_user!(%{email: "foo@bar.com", password: "password"})

      video_lesson1 =
        Content.create_video_lesson!(%{
          unique_code: "lorem-ipsum",
          title: "Lorem Ipsum",
          duration: 10.0,
          video_url: "https://lorem.ipsum"
        })

      video_lesson2 =
        Content.create_video_lesson!(%{
          unique_code: "dolor-sit",
          title: "Dolor Sit",
          duration: 5.0,
          video_url: "https://dolor.sit"
        })

      video_lesson3 =
        Content.create_video_lesson!(%{
          unique_code: "nisi-ut",
          title: "Nisi Ut",
          duration: 15.0,
          video_url: "https://nisi.ut"
        })

      %{user: user, video_lessons: [video_lesson1, video_lesson2, video_lesson3]}
    end

    test "returns the first unwatched video_lesson", %{
      user: user,
      video_lessons: [video_lesson1, video_lesson2, _]
    } do
      create_video_lesson_watch_history_helper(user, video_lesson1)

      assert returned_video_lesson = Content.get_next_video_lesson_for(user)
      assert returned_video_lesson.id == video_lesson2.id
    end

    test "if all video_lessons have been watched, returns the least watched video_lesson (ordered by id)",
         %{user: user, video_lessons: [video_lesson1, video_lesson2, video_lesson3]} do
      # Watched all lessons once
      create_video_lesson_watch_history_helper(user, video_lesson1)
      create_video_lesson_watch_history_helper(user, video_lesson2)
      create_video_lesson_watch_history_helper(user, video_lesson3)

      # Watched video_lesson2 and video_lesson3 again
      create_video_lesson_watch_history_helper(user, video_lesson2)
      create_video_lesson_watch_history_helper(user, video_lesson3)

      assert returned_video_lesson = Content.get_next_video_lesson_for(user)
      assert returned_video_lesson.id == video_lesson1.id
    end
  end

  def create_video_lesson_watch_history_helper(user, video_lesson) do
    UserProgress.create_video_lesson_watch_history(%{
      user_id: user.id,
      video_lesson_id: video_lesson.id,
      watched_at: DateTime.utc_now(),
      duration_watched: video_lesson.duration
    })
  end
end
