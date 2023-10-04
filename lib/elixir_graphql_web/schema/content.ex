defmodule ElixirGraphQLWeb.Schema.Content do
  @moduledoc """
  The GraphQL API schema for the Content context.
  """

  use Absinthe.Schema.Notation

  alias ElixirGraphQL.Content

  object :video_lesson do
    field(:unique_code, non_null(:string))
    field(:title, non_null(:string))
    field(:duration, non_null(:string))
    field(:video_url, non_null(:string))
  end

  object :content_queries do
    field(:video_lesson, :video_lesson) do
      arg(:id, :id)

      resolve(fn %{id: id}, _resolution ->
        case id do
          nil -> {:error, :must_use_id}
          id -> {:ok, Content.get_video_lesson_by(id: id)}
        end
      end)
    end

    field(:get_next_video_lesson, :video_lesson) do
      middleware(ElixirGraphQLWeb.Middlewares.Authentication)

      resolve(fn _args, %{context: %{current_user: current_user}} ->
        case Content.get_next_video_lesson_for(current_user) do
          nil -> {:error, :no_video_lesson_found}
          next_lesson -> {:ok, next_lesson}
        end
      end)
    end
  end
end
