defmodule ElixirGraphQL.Content do
  @moduledoc """
  The Content context.

  Functions related to content.
  """
  import Ecto.Query

  alias ElixirGraphQL.Accounts.User
  alias ElixirGraphQL.Content.VideoLesson
  alias ElixirGraphQL.UserProgress.VideoLessonWatchHistory
  alias ElixirGraphQL.Repo

  require Crudry.Context

  Crudry.Context.generate_functions(VideoLesson)

  # ===================================================================================
  # Public APIs
  # ===================================================================================
  @spec get_next_video_lesson_for(User.t()) :: VideoLesson.t() | nil
  def get_next_video_lesson_for(user) do
    with unwatched_lesson when is_nil(unwatched_lesson) <- get_unwatched_video_lesson(user.id),
         least_viewed_lesson <- get_least_viewed_video_lesson(user.id) do
      least_viewed_lesson
    else
      next_lesson ->
        next_lesson
    end
  end

  # ===================================================================================
  # Private Functions
  # ===================================================================================
  defp get_unwatched_video_lesson(user_id) do
    from(vl in VideoLesson,
      left_join: vlwh in VideoLessonWatchHistory,
      on: vl.id == vlwh.video_lesson_id and vlwh.user_id == ^user_id,
      group_by: vl.id,
      where: is_nil(vlwh.id),
      order_by: [asc: vl.id],
      limit: 1
    )
    |> Repo.one()
  end

  defp get_least_viewed_video_lesson(user_id) do
    from(vl in VideoLesson,
      left_join: vlwh in VideoLessonWatchHistory,
      on: vl.id == vlwh.video_lesson_id and vlwh.user_id == ^user_id,
      group_by: vl.id,
      order_by: [asc: coalesce(count(vlwh.id), 0)],
      limit: 1
    )
    |> Repo.one()
  end
end
