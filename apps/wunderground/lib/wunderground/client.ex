defmodule Wunderground.Client do
  alias Wunderground.API2
  alias Wunderground.Stash

  require Logger

  def current_weather(city, country) do
    Stash.get_age(city, country)
    |> cache_or_fetch(city, country)
  end

  defp cache_or_fetch(nil, city, country), do: fetch(city, country)

  defp cache_or_fetch(age, city, country) do
    # The API is limited to 500 calls a day, which is a little more than
    # one every 3 minutes.
    case Timex.Duration.diff(Timex.Duration.now, age, :seconds) >= 172 do
      true -> fetch(city, country)
      false -> Stash.get_current_weather(city, country)
    end
  end

  defp fetch(city, country) do
    API2.current_weather(city, country)
    |> update_cache(city, country)
  end

  defp update_cache({:ok, current_weather}, city, country) do
    Stash.save_current_weather(city, country, current_weather)
    current_weather
  end

  defp update_cache({:error, response}, _city, _country) do
    Logger.warn "Could not fetch current weather:\n" <> (inspect response)
    :error
  end
end
