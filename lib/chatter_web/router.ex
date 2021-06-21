defmodule ChatterWeb.Router do
  use ChatterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    # plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    # plug Guardian.Plug.LoadResource
  end

  pipeline :authenticate do
    plug ChatterWeb.Plugs.Authenticate
  end


  # Other scopes may use custom stacks.
  scope "/api", ChatterWeb do
    pipe_through([:api])

    # get "/sessions", SessionController, :authenticate #get current session
    post "/sessions", SessionController, :create # login
    delete "/sessions", SessionController, :delete # log out

    resources "/users", UserController , only: [:create, :new]
    get "/users/current", UserController, :current
  end
  scope "/api", ChatterWeb do
    pipe_through([:api, :authenticate])
    # restricted resources here
  end

  scope "/", ChatterWeb do
    pipe_through :browser

    get "/*path", PageController, :index
  end


  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ChatterWeb.Telemetry
    end
  end
end
