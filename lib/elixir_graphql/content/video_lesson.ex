defmodule ElixirGraphQL.Content.VideoLesson do
  @moduledoc """
  Represents a video lesson in the content.
  """

  use TypedEctoSchema

  import Ecto.Changeset

  typed_schema "video_lessons" do
    field(:unique_code, :string)
    field(:title, :string)
    field(:duration, :decimal)
    field(:video_url, :string)
  end

  @required ~w[unique_code title duration video_url]a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required)
    |> validate_required(@required)
    |> unique_constraint(:unique_code, name: :unique_video_lessons_unique_code)
  end
end
