defmodule Thermos.Thermostat.Outside.LatestObservation do
  use GenServer

  @vsn "0"

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def save_observation(observation) do
    GenServer.cast(__MODULE__, {:save_observation, observation})
  end

  def get_observation do
    GenServer.call(__MODULE__, :get_observation)
  end

  def handle_call(:get_observation, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:save_observation, observation}, _state) do
    {:noreply, observation}
  end
end
