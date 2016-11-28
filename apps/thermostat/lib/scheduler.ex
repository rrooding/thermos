defmodule Thermos.Thermostat.Scheduler do
  @moduledoc """
  Schedule a function to call at a given interval in milliseconds

  ## Options

  - `:module`: The module on which to call the function
  - `:function`: The function to call
  - `:args`: A list of arguments to pass to the function
  - `:interval`: The time interval in milliseconds to rerun the function
  - `:start_delayed`: When false, it triggers the function immediately, and then starts the interval, otherwise it will first wait the full interval.

  ## Example

  In a supervisor:

    worker(Thermos.Thermostat.Scheduler, [[
      module: Thermos.Thermostat.Worker,
      function: :do_something,
      args: [],
      interval: 10000
    ]])

  On its own:

    Thermos.Thermostat.Scheduler.start_link([[
      module: Thermos.Thermostat.Worker,
      function: :do_something,
      args: [],
      interval: 10000
    ]])
  """

  use GenServer

  require Logger

  def start_link(opts) do
    {:ok, pid} = GenServer.start_link(__MODULE__, opts)

    Logger.info(~s{Running #{inspect(__MODULE__)} with #{pretty_fun(opts)} using interval #{opts[:interval]}})
    :timer.apply_interval(opts[:interval], __MODULE__, :perform, [pid])

    {:ok, pid}
  end

  def init(opts) do
    if !Keyword.get(opts, :start_delayed, false) do
      :timer.apply_after(100, __MODULE__, :perform, [self()])
    end

    {:ok, opts}
  end

  def perform(scheduler), do: GenServer.cast(scheduler, :perform)

  def handle_cast(:perform, opts) do
    Logger.info(~s{#{inspect(__MODULE__)} running #{pretty_fun(opts)} with args #{inspect(opts[:args])}})
    apply(opts[:module], opts[:function], opts[:args])
    {:noreply, opts}
  end

  defp pretty_fun(opts), do: ~s{#{inspect(opts[:module])}.#{opts[:function]}}
end
