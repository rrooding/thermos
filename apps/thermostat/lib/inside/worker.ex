defmodule Thermos.Thermostat.Inside.Worker do
  @sensor "inside"

  alias Thermos.Thermostat.Influx.Observation
  alias Thermos.Thermostat.Inside.LatestObservation

  defmodule CurrentConditions do
    defstruct temperature: nil, relative_humidity: nil
  end

  def perform do
    Thermos.Sensors.DHT22.read(4)
    |> create_observation
    |> save_to_influx
    |> save_to_cache
  end

  def create_observation(data) do
    %CurrentConditions{}
    |> read_temperature(data)
    |> read_humidity(data)
  end

  defp read_temperature(current_conditions, data) do
    %CurrentConditions{current_conditions | temperature: data["temp"] / 1}
  end

  defp read_humidity(current_conditions, data) do
    %CurrentConditions{current_conditions | relative_humidity: data["humidity"] / 1}
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
          |> Observation.timestamp
          |> Observation.save

    observation
  end
end
