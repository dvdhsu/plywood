defmodule Melamine.Router do
  use Melamine.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug CORSPlug, [origin: "http://localhost:10555"]
    plug :accepts, ["json"]
  end

  scope "/", Melamine do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", Melamine do
    pipe_through :api
    scope "/auth" do
      post "/login", AuthenticationController, :login_or_create
      post "/logout", AuthenticationController, :logout
    end
    resources "/users", UserController, except: [:new, :edit]
  end
end
