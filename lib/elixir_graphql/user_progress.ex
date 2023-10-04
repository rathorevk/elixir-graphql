defmodule ElixirGraphQL.UserProgress do
  @moduledoc """
  The UserProgress context.

  Functions related to tracking a user's progress and activity history.
  """

  alias ElixirGraphQL.Repo
  alias ElixirGraphQL.UserProgress.VideoLessonWatchHistory
  require Crudry.Context

  Crudry.Context.generate_functions(VideoLessonWatchHistory)
end
