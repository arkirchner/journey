defmodule Journey.Repo.Migrations.AddPhotoToEvents do
  use Ecto.Migration

  def change do
    alter table("events") do
      add :photo, :text
    end
  end
end
