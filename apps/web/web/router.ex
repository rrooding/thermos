defmodule Thermos.Web.Router do
  use Thermos.Web.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Thermos.Web do
    pipe_through :api

    get "/setpoint", SetpointController, :show
    put "/setpoint", SetpointController, :update
  end
end
