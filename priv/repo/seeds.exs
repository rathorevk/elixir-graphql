# Run: mix ecto.setup or mix run priv/repo/seeds.exs to seed the database.

alias ElixirGraphQL.Accounts.User
alias ElixirGraphQL.Content.VideoLesson
alias ElixirGraphQL.UserProgress.VideoLessonWatchHistory
alias ElixirGraphQL.Repo

# Create a user
user = %User{email: "user@ElixirGraphQL.co.uk", password: "password"} |> Repo.insert!()

# Create video lessons
video_lesson1 =
  %VideoLesson{
    unique_code: "linear-equations",
    title: "Linear Equations",
    duration: 10.0,
    video_url: "https://youtu.be/Ft2_QtXAnh8"
  }
  |> Repo.insert!()

%VideoLesson{
  unique_code: "quadratic-equations",
  title: "Quadratic Equations",
  duration: 15.0,
  video_url: "https://youtu.be/7JhjINPwfYQ"
}
|> Repo.insert!()

# Create video lesson watch history
%VideoLessonWatchHistory{
  user_id: user.id,
  video_lesson_id: video_lesson1.id,
  watched_at: DateTime.utc_now() |> DateTime.truncate(:second),
  duration_watched: 5.0
}
|> Repo.insert!()
