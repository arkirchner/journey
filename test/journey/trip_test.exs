defmodule Journey.TripTest do
  use Journey.DataCase

  alias Journey.Trip

  describe "events" do
    alias Journey.Trip.Event

    image_upload = %Plug.Upload{
      content_type: "image/png",
      filename: "photo.png",
      path: "./test/support/fixtures/image.png"
    }

    @valid_attrs %{name: "some name", photo: image_upload}
    @update_attrs %{name: "some updated name", photo: image_upload}
    @invalid_attrs %{name: nil, photo: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Trip.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Trip.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Trip.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Trip.create_event(@valid_attrs)
      assert event.name == "some name"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trip.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, %Event{} = event} = Trip.update_event(event, @update_attrs)
      assert event.name == "some updated name"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Trip.update_event(event, @invalid_attrs)
      assert event == Trip.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Trip.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Trip.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Trip.change_event(event)
    end
  end
end
