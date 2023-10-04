defmodule ElixirGraphQLWeb.Schema.UserProgressTest do
  use ElixirGraphQLWeb.ConnCase, async: false

  @video_lesson_watch_history_query """
  query getAllVideoLessonWatchHistory {
    allVideoLessonWatchHistory {
      video_lesson {
        unique_code
        title
        duration
        video_url
      }
      watched_at
      duration_watched
    }
  }
  """

  describe "query: all_video_lesson_watch_history" do
    test "when current_user is not present", %{conn: conn} do
      assert {:error, errors, _} = run_graphql(conn, @video_lesson_watch_history_query, %{})

      assert [%{"message" => "unauthenticated"}] = errors
    end

    test "when current_user is present", %{conn: conn} do
      user = ElixirGraphQL.Accounts.create_user!(%{email: "foo@bar.com", password: "password"})

      video_lesson =
        ElixirGraphQL.Content.create_video_lesson!(%{
          unique_code: "lorem-ipsum",
          title: "Lorem Ipsum",
          duration: 10.0,
          video_url: "https://lorem.ipsum"
        })

      video_lesson_watch_history =
        ElixirGraphQL.UserProgress.create_video_lesson_watch_history!(%{
          user_id: user.id,
          video_lesson_id: video_lesson.id,
          watched_at: DateTime.utc_now(),
          duration_watched: 10.0
        })

      assert {:ok, %{"allVideoLessonWatchHistory" => [response]}} =
               conn
               |> authenticated(user)
               |> run_graphql(@video_lesson_watch_history_query, %{})

      assert response["video_lesson"]["unique_code"] == video_lesson.unique_code
      assert response["video_lesson"]["title"] == video_lesson.title
      assert response["video_lesson"]["duration"] == video_lesson.duration |> Decimal.to_string()
      assert response["video_lesson"]["video_url"] == video_lesson.video_url

      assert response["watched_at"] ==
               video_lesson_watch_history.watched_at |> DateTime.to_string()

      assert response["duration_watched"] ==
               video_lesson_watch_history.duration_watched |> Decimal.to_string()
    end
  end
end
