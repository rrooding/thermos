defmodule Thermos.Web.InsideConditions.Supervisor do
  use Supervisor

  def start_link do
    {:ok, _pid} = Supervisor.start_link(__MODULE__, [])
  end

  def init(_state) do
    supervise child_processes, strategy: :one_for_one
  end

  defp child_processes do
    [
      worker(Thermos.Web.InsideConditions.LatestObservation, []),
      worker(Thermos.Web.InsideConditions.Worker, [])
    ]
  end
end
