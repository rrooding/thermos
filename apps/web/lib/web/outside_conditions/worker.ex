defmodule Thermos.Web.OutsideConditions.Worker do
  require Logger

  alias Thermos.Web.OutsideConditions.LatestObservation
  #alias Thermostat.Fluxter

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    schedule_work(:now)
    {:ok, state}
  end

  def handle_info(:work, state) do
    Wunderground.Client.current_weather("Eindhoven", "Netherlands")
    |> save_to_influx
    |> save_to_cache

    schedule_work()
    {:noreply, state}
  end

  defp save_to_cache(observation) do
    LatestObservation.save_observation(observation)
    observation
  end

  defp save_to_influx(observation) do
    if observation.temperature do
      Logger.debug "Should be saving: " <> (inspect observation)
      #Fluxter.write("temperature", [sensor: "outside"], observation.temperature)
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
