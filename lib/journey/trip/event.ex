defmodule Journey.Trip.Event do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :name, :string
    field :photo, Journey.Photo.Type

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name])
    |> cast_attachments(attrs, [:photo])
    |> validate_required([:name, :photo])
  end
end
