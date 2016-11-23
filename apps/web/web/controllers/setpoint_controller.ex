defmodule Thermos.Web.SetpointController do
  use Thermos.Web.Web, :controller

  require Logger

  def show(conn, _params) do
    setpoint = Thermos.Thermostat.Setpoint.Server.get_setpoint
    render(conn, "show.json", setpoint: setpoint)
  end

  def update(conn, %{"setpoint" => setpoint}) do
    {setpoint_f, _} = Float.parse(setpoint)
    Thermos.Thermostat.Setpoint.Server.update_setpoint(setpoint_f)
    render(conn, "show.json", setpoint: setpoint)
  end
end
