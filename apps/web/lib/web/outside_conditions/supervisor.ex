defmodule Thermos.Web.OutsideConditions.Supervisor do
  use Supervisor

  def start_link do
    {:ok, _pid} = Supervisor.start_link(__MODULE__, [])
  end

  def init(_state) do
    supervise child_processes, strategy: :one_for_one
  end

  defp child_processes do
    [
      worker(Thermos.Web.OutsideConditions.LatestObservation, []),
      worker(Thermos.Web.OutsideConditions.Worker, [])
    ]
  end
end
