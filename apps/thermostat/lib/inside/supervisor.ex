defmodule Thermos.Thermostat.Inside.Supervisor do
  use Supervisor

  def start_link do
    {:ok, _pid} = Supervisor.start_link(__MODULE__, [])
  end

  def init(_state) do
    supervise child_processes, strategy: :one_for_one
  end

  defp child_processes do
    [
      worker(Thermos.Thermostat.Inside.LatestObservation, []),
      worker(Thermos.Thermostat.Scheduler, [[
               module: Thermos.Thermostat.Inside.Worker,
               function: :perform, args: [], interval: 60_000 ]])
    ]
  end
end
