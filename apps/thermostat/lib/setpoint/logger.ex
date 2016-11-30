defmodule Thermos.Thermostat.Setpoint.Logger do
  @sensor "setpoint"

  alias Thermos.Thermostat.Influx.Observation
  alias Thermos.Thermostat.Setpoint.Server

  def perform do
    Server.get_setpoint
    |> save_to_influx
  end

  defp save_to_influx(:error), do: :error
  defp save_to_influx(setpoint) do
    :ok = Observation.new
          |> Observation.sensor(@sensor)
          |> Observation.temperature(setpoint)
          |> Observation.timestamp
          |> Observation.save

    setpoint
  end
end
