defmodule ElixirGraphQL.UserProgress.VideoLessonWatchHistory do
  @moduledoc """
  A record of a video lesson been watched by a user.
  """

  use TypedEctoSchema

  import Ecto.Changeset

  typed_schema "video_lesson_watch_history" do
    belongs_to(:video_lesson, ElixirGraphQL.Content.VideoLesson)
    belongs_to(:user, ElixirGraphQL.Accounts.User)
    field(:watched_at, :utc_datetime)
    field(:duration_watched, :decimal)
  end

  @required ~w[video_lesson_id user_id watched_at duration_watched]a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required)
    |> validate_required(@required)
    |> cast_assoc(:video_lesson)
    |> cast_assoc(:user)
    |> assoc_constraint(:video_lesson)
    |> assoc_constraint(:user)
  end
end
