defmodule OpenWeathermap.API do
  @api_key Application.get_env(:open_weathermap, :api_key)

  require Logger

  def current_weather(city, country) do
    Logger.info("Fetching current weather: " <> @api_key)
    url(city, country)
    |> HTTPoison.get
    |> handle_response
  end

  defp url(city, country) do
    Logger.info("Fetching current weather: " <> "http://api.openweathermap.org/data/2.5/weather?q=#{city},#{country}&appid=#{@api_key}&units=metric")
    "http://api.openweathermap.org/data/2.5/weather?q=#{city},#{country}&appid=#{@api_key}&units=metric"
  end

  defp handle_response({:ok, response}) do
    response.body
    |> Poison.decode!
    |> Map.fetch("main")
    |> parse(response)
    |> respond
  end

  defp handle_response({:error, response}) do
    Logger.warn("Error fetching Open Weathermap API:\n" <> (inspect response))
    {:error, response}
  end

  defp parse({:ok, data}, _response) do
    %OpenWeathermap.CurrentWeather{}
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
    %OpenWeathermap.CurrentWeather{current_weather | temperature: data["temp"] / 1}
  end

  defp read_humidity(current_weather, data) do
    %OpenWeathermap.CurrentWeather{current_weather | relative_humidity: data["humidity"] / 1}
  end

  defp read_air_pressure(current_weather, data) do
    %OpenWeathermap.CurrentWeather{current_weather | air_pressure: data["pressure"] / 1}
  end
end
