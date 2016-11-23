defmodule Thermos.Web.SetpointView do
  use Thermos.Web.Web, :view

  def render("show.json", %{setpoint: setpoint}) do
    %{setpoint: setpoint}
  end
end
