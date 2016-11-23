defmodule Thermos.Sensors.Sensor do
  @name __MODULE__

  use GenServer

  def start_link do
    {:ok, _pid} = GenServer.start_link(@name, %{}, name: @name)
  end

  def read(type, identifier, opts) do
    GenServer.call(@name, {:read, type, identifier, opts})
  end

  def handle_call({:read, type, identifier, opts}, _from, state) do
    {pid, state} = global_identifier(type, identifier)
                   |> find_server(state, type, opts)

    result = GenServer.call(pid, :read)
    {:reply, result, state}
  end

  defp global_identifier(type, identifier), do: ~s(#{type}##{identifier})

  defp find_server(identifier, state, type, opts) do
    case state do
      %{^identifier => server} -> {server, state}
      _ -> new_server(identifier, state, type, opts)
    end
  end

  defp new_server(identifier, state, type, opts) do
    {:ok, server} = type_module(type).start_link(opts)
    {server, Map.put(state, identifier, server)}
  end

  defp type_module(:dht22), do: Thermos.Sensors.DHT22
end
