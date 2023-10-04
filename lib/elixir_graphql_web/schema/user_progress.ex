defmodule ElixirGraphQLWeb.Schema.UserProgress do
  @moduledoc """
  The GraphQL API schema for the UserProgress context.
  """

  use Absinthe.Schema.Notation

  alias ElixirGraphQL.UserProgress

  object :video_lesson_watch_history do
    field(:video_lesson, non_null(:video_lesson))
    field(:user, non_null(:user))
    field(:watched_at, non_null(:string))
    field(:duration_watched, non_null(:string))
  end

  object :user_progress_queries do
    field(:all_video_lesson_watch_history, list_of(:video_lesson_watch_history)) do
      middleware(ElixirGraphQLWeb.Middlewares.Authentication)

      resolve(fn _, %{context: %{current_user: current_user}} ->
        {:ok,
         UserProgress.list_video_lesson_watch_history_with_assocs([:user, :video_lesson],
           user: current_user
         )}
      end)
    end
  end
end
