defmodule Wunderground.API do
  @api_key Application.get_env(:wunderground, :api_key)

  require Logger

  def current_weather(city, country) do
    Logger.debug("Fetching current weather: " <> @api_key)
    url(city, country)
    |> HTTPoison.get
    |> handle_response
  end

  defp url(city, country) do
    "http://api.wunderground.com/api/#{@api_key}/conditions/q/#{country}/#{city}.json"
  end

  defp handle_response({:ok, response}) do
    response.body
    |> Poison.decode!
    |> Map.fetch("current_observation")
    |> parse(response)
    |> respond
  end

  defp handle_response({:error, response}) do
    Logger.warn("Error fetching WeatherUnderground API:\n" <> (inspect response))
    {:error, response}
  end

  defp parse({:ok, data}, _response) do
    %Wunderground.CurrentWeather{}
    |> read_temperature(data)
    |> read_humidity(data)
    |> read_air_pressure(data)
  end

  defp parse(:error, response) do
    Logger.warn("Error parsing JSON:\n:" <> (inspect response))
    {:error, response}
  end

  defp respond({:error, response}), do: {:error, response}
  defp respond(current_weather), do: {:ok, current_weather}

  defp read_temperature(current_weather, data) do
    %Wunderground.CurrentWeather{current_weather | temperature: data["temp_c"]}
  end

  defp read_humidity(current_weather, data) do
    {humidity, _} = Integer.parse(data["relative_humidity"])
    %Wunderground.CurrentWeather{current_weather | relative_humidity: humidity}
  end

  defp read_air_pressure(current_weather, data) do
    %Wunderground.CurrentWeather{current_weather | air_pressure: String.to_integer(data["pressure_mb"])}
  end
end
