defmodule Thermos.Web.ThermostatChannel do
  use Thermos.Web.Web, :channel

  alias Thermos.Web.Endpoint
  alias Thermos.Thermostat.Inside.LatestObservation, as: Inside
  alias Thermos.Thermostat.Setpoint.Server, as: Setpoint
  alias Thermos.Thermostat.Controller.Stash, as: Thermostat

  def join("thermostat", _payload, socket) do
    send self(), :after_join
    {:ok, socket}
  end

  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_info(:after_join, socket) do
    broadcast_status(socket)
    {:noreply, socket}
  end

  def broadcast_status(socket), do: broadcast socket, "new:msg", message()
  def broadcast_status,         do: broadcast "thermostat", "new:msg", message()

  defp message do
    %{
      "temperature" => inside().temperature,
      "relative_humidity" => inside().relative_humidity,
      "setpoint" => setpoint(),
      "heating" => heating?()
    }
  end

  defp inside, do: Inside.get_observation

  defp setpoint, do: Setpoint.get_setpoint

  defp heating?, do: Thermostat.get_state
end
