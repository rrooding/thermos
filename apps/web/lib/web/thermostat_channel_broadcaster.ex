defmodule Thermos.Web.ThermostatChannelBroadcaster do
  def perform do
    Thermos.Web.ThermostatChannel.broadcast_status
  end
end
