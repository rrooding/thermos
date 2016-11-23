defmodule Thermos.Sensors.DHT22 do
  @name __MODULE__
  @sensor_type :dht22
  @dht22_bin Application.get_env(:sensors, :dht22_bin)

  use GenServer

  def start_link(opts) do
    GenServer.start_link(@name, opts)
  end

  def read(gpio_pin) do
    Thermos.Sensors.Sensor.read(@sensor_type, gpio_pin, [gpio_pin: gpio_pin])
  end

  def handle_call(:read, _from, state) do
    {:ok, pin} = Keyword.fetch(state, :gpio_pin)
    result = exec_cmd(pin) |> Poison.decode!
    {:reply, result, state}
  end

  defp cmd, do: Path.join(Application.app_dir(:sensors, "priv"), @dht22_bin)

  defp exec_cmd(pin) when is_integer(pin), do: exec_cmd(Integer.to_string(pin))
  defp exec_cmd(pin) when is_binary(pin),  do: System.cmd(cmd, [pin]) |> cmd_output

  defp cmd_output({output, 0}), do: output
end
