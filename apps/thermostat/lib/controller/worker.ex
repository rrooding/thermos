defmodule Thermos.Thermostat.Controller.Worker do
  require Logger

  alias Thermos.Thermostat.Controller.Hysteresis, as: Driver
  alias Thermos.Thermostat.Controller.Stash
  alias Thermos.Thermostat.Influx.HeatingState

  def perform do
    current_state = Stash.get_state
    setpoint = Thermos.Thermostat.Setpoint.Server.get_setpoint
    %{temperature: indoor} = Thermos.Thermostat.Inside.LatestObservation.get_observation
    Logger.debug("It is #{indoor} but it should be #{setpoint}")

    Driver.heating?(current_state, indoor, setpoint)
    |> save_to_influx
    |> save_to_cache
    |> debug_log
  end

  defp save_to_cache(state) do
    Stash.update_state(state)
    state
  end

  def save_to_influx(state) do
    :ok = HeatingState.new
          |> HeatingState.state(state)
          |> HeatingState.timestamp
          |> HeatingState.save

    state
  end

  defp debug_log(true), do: Logger.info("Heating")
  defp debug_log(false), do: Logger.info("Idling")
end
