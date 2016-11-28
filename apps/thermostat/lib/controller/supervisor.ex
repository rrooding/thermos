defmodule Thermos.Thermostat.Controller.Supervisor do
  use Supervisor

  def start_link do
    {:ok, _pid} = Supervisor.start_link(__MODULE__, [])
  end

  def init(_state) do
    supervise child_processes, strategy: :one_for_one
  end

  defp child_processes do
    [
      worker(Thermos.Thermostat.Controller.Stash, []),
      worker(Thermos.Thermostat.Scheduler, [[
               module: Thermos.Thermostat.Controller.Worker,
               function: :perform, args: [], interval: 30_000, start_delayed: true ]])
    ]
  end
end
