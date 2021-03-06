defmodule Urn.Router do
  use Urn.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json", "multipart"]
    plug Urn.Authentication.Params
  end

  scope "/", Urn do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :create
  end

  scope "/api", Urn do
    pipe_through :api

    get  "/files/whereis",   FileController, :whereis
    post "/files/create",    FileController, :create
    get  "/files/read",      FileController, :read
    post "/files/replicate", FileController, :replicate
    get  "/files/delete",    FileController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", Urn do
  #   pipe_through :api
  # end
end
