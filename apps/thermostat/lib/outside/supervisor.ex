defmodule Thermos.Thermostat.Outside.Supervisor do
  use Supervisor

  def start_link do
    {:ok, _pid} = Supervisor.start_link(__MODULE__, [])
  end

  def init(_state) do
    supervise child_processes(), strategy: :one_for_one
  end

  defp child_processes do
    [
      worker(Thermos.Thermostat.Outside.LatestObservation, []),
      worker(Thermos.Utils.Scheduler, [[
               module: Thermos.Thermostat.Outside.Worker,
               function: :perform, args: [], interval: 300_000 ]])
    ]
  end
end
