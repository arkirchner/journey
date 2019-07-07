defmodule JourneyWeb.Router do
  use JourneyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JourneyWeb do
    pipe_through :browser

    resources "/events", EventController
    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", JourneyWeb do
  #   pipe_through :api
  # end
end
