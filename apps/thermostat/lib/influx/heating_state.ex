defmodule Thermos.Thermostat.Influx.HeatingState do
  use Instream.Series

  alias Thermos.Thermostat.Influx.Connection

  series do
    database "thermos"
    measurement "heating"

    tag :heater, default: "central_heater"

    field :state
  end

  @doc """
    Returns a new HeatingState

    ## Examples

        iex> HeatingState.new
        %HeatingState{}

  """
  def new, do: %__MODULE__{}

  @doc """
    Update the heating state

    ## Examples

        iex> hs = HeatingState.new
        iex> hs |> state(true)
        %HeatingState{fields: %HeatingState.Fields{state: true}}

  """
  def state(heating_state, value), do: field(heating_state, %{state: value})

  @doc """
    Update the heater

    ## Examples

        iex> hs = HeatingState.new
        iex> hs |> heater("electric_heater")
        %HeatingState{tags: %HeatingState.Tags{heater: "electric_heater"}}

  """
  def heater(heating_state, value), do: tag(heating_state, %{heater: value})

  @doc """
    Update the timestamp to the current system time
  """
  def timestamp(heating_state), do: timestamp(heating_state, :os.system_time(:seconds))

  @doc """
    Update the timestamp on the heating state

    ## Examples

        iex> hs = HeatingState.new
        iex> hs |> timestamp(123456)
        %HeatingState{timestamp: 123456}

  """
  def timestamp(heating_state, value) when is_integer(value), do: %{heating_state | timestamp: value}

  @doc """
    Updates a field on the heating state

    ## Examples

        iex> hs = HeatingState.new
        iex> hs |> field(%{state: 1.0})
        %HeatingState{fields: %HeatingState.Fields{state: 1.0}}
  """
  def field(heating_state, value), do: %{heating_state | fields: Map.merge(heating_state.fields, value)}

  @doc """
    Updates a tag on the heating state

    ## Examples

        iex> hs = HeatingState.new
        iex> hs |> tag(%{heater: "heating_pump"})
        %HeatingState{tags: %HeatingState.Tags{heater: "heating_pump"}}
  """
  def tag(heating_state, value), do: %{heating_state | tags: Map.merge(heating_state.tags, value)}

  @doc """
    Save the heating state to InfluxDB
  """
  def save(heating_state), do: Connection.write(heating_state, precision: :seconds)
end
