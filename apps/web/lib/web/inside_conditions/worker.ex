defmodule Thermos.Web.InsideConditions.Worker do
  require Logger

  alias Thermos.Web.InsideConditions.LatestObservation
  alias Thermos.Web.Instream.Observation

  use GenServer

  defmodule CurrentConditions do
    defstruct temperature: nil, relative_humidity: nil, air_pressure: nil
  end

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    schedule_work(:now)
    {:ok, state}
  end

  def handle_info(:work, state) do
    Thermos.Web.Sensors.DHT22.read(4)
    |> Poison.decode!
    |> create_observation
    |> save_to_influx
    |> save_to_cache

    schedule_work()
    {:noreply, state}
  end

  def create_observation(data) do
    %CurrentConditions{}
    |> read_temperature(data)
    |> read_humidity(data)
    |> read_air_pressure(data)
  end

  defp read_temperature(current_conditions, data) do
    %CurrentConditions{current_conditions | temperature: data["temp"] / 1}
  end

  defp read_humidity(current_conditions, data) do
    %CurrentConditions{current_conditions | relative_humidity: data["humidity"] / 1}
  end

  defp read_air_pressure(current_conditions, data) do
    %CurrentConditions{current_conditions | air_pressure: data["pressure"] / 1}
  end

  defp save_to_cache(:error), do: :error
  defp save_to_cache(observation) do
    LatestObservation.save_observation(observation)
    observation
  end

  defp save_to_influx(:error), do: :error
  defp save_to_influx(observation) do
    if observation.temperature do
      Logger.debug "Should be saving: " <> (inspect observation)
      data = %Observation{}
      data = %{data | fields: %{data.fields | temperature: observation.temperature}}
      data = %{data | fields: %{data.fields | relative_humidity: observation.relative_humidity}}
      data = %{data | fields: %{data.fields | air_pressure: observation.air_pressure}}
      data = %{data | tags: %{data.tags | sensor: "inside"}}
      data = %{data | timestamp: :os.system_time(:seconds)}

      data
      |> Thermos.Web.Instream.Connection.write(precision: :seconds)
      Logger.debug "Trying writing: " <> (inspect data)
    else
      Logger.info("Not saving to influx because nil")
    end
    observation
  end

  defp schedule_work(delay \\ 5 * 60 * 1000)

  defp schedule_work(:now), do: schedule_work(0)

  defp schedule_work(delay) do
    # Default delay is 5 minutes
    Process.send_after(self(), :work, delay)
  end
end
