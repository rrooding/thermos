defmodule Thermos.Thermostat.Setpoint.Server do
  @low_safety_temperature Application.get_env(:thermostat, :low_safety_temperature)
  @name __MODULE__

  use GenServer

  @doc """
    Start the Setpoint server

    ## Options

    - `:name`: Start a server with a specific name (default: __MODULE__)
    - `:setpoint`: Start with this setpoint (default: config.low_safety_temperature)

    ## Examples

        iex> start_link(name: :setpoint_default)
        iex> get_setpoint(:setpoint_default)
        10.0

        iex> start_link(name: :setpoint_test, setpoint: 13.0)
        iex> get_setpoint(:setpoint_test)
        13.0
  """
  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @name)
    {setpoint, opts} = Keyword.pop(opts, :setpoint, @low_safety_temperature)
    {:ok, _pid} = GenServer.start_link(__MODULE__, setpoint, opts)
  end

  @doc """
    Update the current setpoint to `setpoint`.

    ## Examples

        iex> update_setpoint(17.0)
        iex> get_setpoint
        17.0

        iex> update_setpoint(16)
        iex> get_setpoint
        16.0

  """
  def update_setpoint(name \\ @name, setpoint)
  def update_setpoint(name, setpoint) when is_float(setpoint),   do: GenServer.cast name, {:update_setpoint, setpoint}
  def update_setpoint(name, setpoint) when is_integer(setpoint), do: update_setpoint(name, setpoint / 1)


  @doc """
    Retreives the current setpoint.

    ## Examples

        iex> update_setpoint(15.0)
        iex> get_setpoint
        15.0

  """
  def get_setpoint(name \\ @name), do: GenServer.call name, :get_setpoint

  # GenServer interface

  @doc false
  def handle_cast({:update_setpoint, setpoint}, _state) do
    {:noreply, setpoint}
  end

  @doc false
  def handle_call(:get_setpoint, _from, state) do
    {:reply, state, state}
  end
end
