defmodule ElixirGraphQLWeb.Schema.ContentTest do
  use ElixirGraphQLWeb.ConnCase, async: false

  @video_lesson_query """
  query getVideoLesson($id: ID!) {
    videoLesson(id: $id) {
      unique_code
      title
      duration
      video_url
    }
  }
  """

  describe "query: videoLesson" do
    test "when id is not passed", %{conn: conn} do
      assert {:error, errors, _} = run_graphql(conn, @video_lesson_query, %{})

      assert [%{"message" => "Variable \"id\": Expected non-null, found null."}] = errors
    end

    test "when id is passed", %{conn: conn} do
      video_lesson =
        ElixirGraphQL.Content.create_video_lesson!(%{
          unique_code: "lorem-ipsum",
          title: "Lorem Ipsum",
          duration: 10.0,
          video_url: "https://lorem.ipsum"
        })

      assert {:ok, %{"videoLesson" => response}} =
               run_graphql(conn, @video_lesson_query, %{id: video_lesson.id})

      assert response["unique_code"] == video_lesson.unique_code
      assert response["title"] == video_lesson.title
      assert response["duration"] == video_lesson.duration |> Decimal.to_string()
      assert response["video_url"] == video_lesson.video_url
    end
  end

  @get_next_video_lesson_query """
  query getNextVideoLesson {
    getNextVideoLesson {
      unique_code
      title
      duration
      video_url
    }
  }
  """

  describe "query: get_next_video_lesson" do
    test "when current_user is not present", %{conn: conn} do
      assert {:error, errors, _} = run_graphql(conn, @get_next_video_lesson_query, %{})

      assert [%{"message" => "unauthenticated"}] = errors
    end

    test "when current_user is present but no lesson exist", %{conn: conn} do
      user = ElixirGraphQL.Accounts.create_user!(%{email: "foo@bar.com", password: "password"})

      assert {:error, errors, _} =
               conn
               |> authenticated(user)
               |> run_graphql(@get_next_video_lesson_query, %{})

      assert [%{"message" => "no_video_lesson_found"}] = errors
    end

    test "when unwatched video is present", %{conn: conn} do
      user = ElixirGraphQL.Accounts.create_user!(%{email: "foo@bar.com", password: "password"})

      video_lesson_1 =
        ElixirGraphQL.Content.create_video_lesson!(%{
          unique_code: "lesson-1",
          title: "lesson 1",
          duration: 10.0,
          video_url: "https://ElixirGraphQL.co.uk/category-1/lesson-1"
        })

      video_lesson_2 =
        ElixirGraphQL.Content.create_video_lesson!(%{
          unique_code: "lesson-2",
          title: "lesson 2",
          duration: 10.0,
          video_url: "https://ElixirGraphQL.co.uk/category-1/lesson-2"
        })

      _video_lesson_watch_history =
        ElixirGraphQL.UserProgress.create_video_lesson_watch_history!(%{
          user_id: user.id,
          video_lesson_id: video_lesson_1.id,
          watched_at: DateTime.utc_now(),
          duration_watched: 10.0
        })

      assert {:ok, %{"getNextVideoLesson" => response}} =
               conn
               |> authenticated(user)
               |> run_graphql(@get_next_video_lesson_query, %{})

      assert response["unique_code"] == video_lesson_2.unique_code
      assert response["title"] == video_lesson_2.title
      assert response["video_url"] == video_lesson_2.video_url

      assert response["duration"] ==
               video_lesson_2.duration |> Decimal.to_string()
    end

    test "when unwatched video is not present then get least viewed video", %{conn: conn} do
      user = ElixirGraphQL.Accounts.create_user!(%{email: "foo@bar.com", password: "password"})

      video_lesson_1 =
        ElixirGraphQL.Content.create_video_lesson!(%{
          unique_code: "lesson-1",
          title: "lesson 1",
          duration: 10.0,
          video_url: "https://ElixirGraphQL.co.uk/category-1/lesson-1"
        })

      video_lesson_2 =
        ElixirGraphQL.Content.create_video_lesson!(%{
          unique_code: "lesson-2",
          title: "lesson 2",
          duration: 10.0,
          video_url: "https://ElixirGraphQL.co.uk/category-1/lesson-2"
        })

      _vlwh_1 =
        ElixirGraphQL.UserProgress.create_video_lesson_watch_history!(%{
          user_id: user.id,
          video_lesson_id: video_lesson_1.id,
          watched_at: DateTime.utc_now(),
          duration_watched: 10.0
        })

      _vlwh_2 =
        ElixirGraphQL.UserProgress.create_video_lesson_watch_history!(%{
          user_id: user.id,
          video_lesson_id: video_lesson_2.id,
          watched_at: DateTime.utc_now(),
          duration_watched: 10.0
        })

      _vlwh_3 =
        ElixirGraphQL.UserProgress.create_video_lesson_watch_history!(%{
          user_id: user.id,
          video_lesson_id: video_lesson_2.id,
          watched_at: DateTime.utc_now(),
          duration_watched: 10.0
        })

      assert {:ok, %{"getNextVideoLesson" => response}} =
               conn
               |> authenticated(user)
               |> run_graphql(@get_next_video_lesson_query, %{})

      assert response["unique_code"] == video_lesson_1.unique_code
      assert response["title"] == video_lesson_1.title
      assert response["video_url"] == video_lesson_1.video_url

      assert response["duration"] ==
               video_lesson_1.duration |> Decimal.to_string()
    end
  end
end
