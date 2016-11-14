defmodule Wunderground.Stash do
  use GenServer

  require Logger

  @vsn "0"

  defmodule SubState do
    defstruct age: nil, current_weather: nil
  end

  def start_link do
    {:ok, _pid} = GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def save_current_weather(city, country, current_weather) do
    GenServer.cast __MODULE__, {:save_current_weather, hash_key(city, country), current_weather}
  end

  def get_current_weather(city, country) do
    GenServer.call __MODULE__, {:get_current_weather, hash_key(city, country)}
  end

  def get_age(city, country) do
    GenServer.call __MODULE__, {:get_age, hash_key(city, country)}
  end

  defp hash_key(city, country), do: "#{country}/#{city}"

  def handle_cast({:save_current_weather, key, current_weather}, state) do
    {:noreply, Map.put(state, key, %SubState{age: Timex.Duration.now, current_weather: current_weather})}
  end

  def handle_call({:get_current_weather, key}, _from, state) do
    {:reply, Map.get(state, key, %SubState{}).current_weather, state}
  end

  def handle_call({:get_age, key}, _from, state) do
    {:reply, Map.get(state, key, %SubState{}).age, state}
  end
end
