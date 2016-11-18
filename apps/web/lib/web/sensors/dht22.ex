defmodule Thermos.Web.Sensors.DHT22 do
  @dht22_bin Application.get_env(:web, Thermos.Web.Sensors)[:dht22_bin]

  require Logger

  def read(pin) when is_integer(pin), do: Integer.to_string(pin) |> read

  def read(pin) when is_binary(pin) do
    Logger.info("Running for inside: " <> application)
    System.cmd(application, ["22", pin])
    |> handle_output
  end

  defp handle_output({output, 0}), do: output

  defp application do
    if String.starts_with?(@dht22_bin, "/") do
      @dht22_bin
    else
      relative_application(@dht22_bin)
    end
  end

  defp relative_application(app), do: Path.join(Application.app_dir(:web, "priv"), app)
end
