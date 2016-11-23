defmodule Thermos.Thermostat.Outside.Worker do
  @location Application.get_env(:thermostat, :location)
  @sensor "outside"

  alias Thermos.Thermostat.Influx.Observation
  alias Thermos.Thermostat.Outside.LatestObservation

  def perform do
    OpenWeathermap.Client.current_weather(@location[:city], @location[:country])
    |> save_to_influx
    |> save_to_cache
  end

  defp save_to_cache(:error), do: :error
  defp save_to_cache(observation) do
    LatestObservation.save_observation(observation)
    observation
  end

  defp save_to_influx(:error), do: :error
  defp save_to_influx(observation) do
    :ok = Observation.new
          |> Observation.sensor(@sensor)
          |> Observation.temperature(observation.temperature)
          |> Observation.relative_humidity(observation.relative_humidity)
          |> Observation.air_pressure(observation.air_pressure)
          |> Observation.timestamp
          |> Observation.save

    observation
  end
end
