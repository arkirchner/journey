defmodule JourneyWeb.PageController do
  use JourneyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
