defmodule Wunderground.API2 do
  @api_key Application.get_env(:wunderground, :api_key)

  require Logger

  def current_weather(city, country) do
    Logger.debug("Fetching current weather: " <> @api_key)
    url(city, country)
    |> HTTPoison.get
    |> handle_response
  end

  defp url(city, country) do
    #"http://api.wunderground.com/api/#{@api_key}/conditions/q/#{country}/#{city}.json"
    #"http://api.wunderground.com/api/#{@api_key}/conditions/q/pws:IEINDHOV17.json"
    "http://api.openweathermap.org/data/2.5/weather?q=Eindhoven,NL&appid=#{@api_key}&units=metric"
  end

  defp handle_response({:ok, response}) do
    response.body
    |> Poison.decode!
    |> Map.fetch("main")
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
    %Wunderground.CurrentWeather{current_weather | temperature: data["temp"] / 1}
  end

  defp read_humidity(current_weather, data) do
    %Wunderground.CurrentWeather{current_weather | relative_humidity: data["humidity"] / 1}
  end

  defp read_air_pressure(current_weather, data) do
    %Wunderground.CurrentWeather{current_weather | air_pressure: data["pressure"] / 1}
  end
end
