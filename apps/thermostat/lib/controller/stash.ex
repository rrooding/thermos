defmodule Thermos.Thermostat.Controller.Stash do
  @name __MODULE__

  use GenServer

  @doc """
    Start the Controller Stash

    ## Options

    - `:name`: Start a server with a specific name (default: __MODULE__)
    - `:state`: Start with this state (default: false)

    ## Examples

        iex> start_link(name: :state_default)
        iex> get_state(:state_default)
        false

        iex> start_link(name: :state_test, state: true)
        iex> get_state(:state_test)
        true
  """
  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @name)
    {state, opts} = Keyword.pop(opts, :state, false)
    {:ok, _pid} = GenServer.start_link(__MODULE__, state, opts)
  end

  @doc """
    Update the current controller state to `state`.

    ## Examples

        iex> update_state(true)
        iex> get_state
        17.0

        iex> update_state(16)
        iex> get_state
        16.0

  """
  def update_state(name \\ @name, state)
  def update_state(name, state) when is_boolean(state), do: GenServer.cast name, {:update_state, state}


  @doc """
    Retreives the current state.

    ## Examples

        iex> update_state(15.0)
        iex> get_state
        15.0

  """
  def get_state(name \\ @name), do: GenServer.call name, :get_state

  # GenServer interface

  @doc false
  def handle_cast({:update_state, state}, _state) do
    {:noreply, state}
  end

  @doc false
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end
end
