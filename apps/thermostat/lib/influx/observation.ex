defmodule Thermos.Thermostat.Influx.Observation do
  use Instream.Series

  alias Thermos.Thermostat.Influx.Connection

  series do
    database "thermos"
    measurement "observation"

    tag :sensor

    field :temperature
    field :relative_humidity
    field :air_pressure
  end

  @doc """
    Returns a new Observation

    ## Examples

        iex> Observation.new
        %Observation{}

  """
  def new, do: %__MODULE__{}

  @doc """
    Update the temperature on the observation

    ## Examples

        iex> obs = Observation.new
        iex> obs |> temperature(16.0)
        %Observation{fields: %Observation.Fields{temperature: 16.0}}

  """
  def temperature(observation, value), do: field(observation, %{temperature: value})

  @doc """
    Update the relative humidity on the observation

    ## Examples

        iex> obs = Observation.new
        iex> obs |> relative_humidity(98.0)
        %Observation{fields: %Observation.Fields{relative_humidity: 98.0}}

  """
  def relative_humidity(observation, value), do: field(observation, %{relative_humidity: value})

  @doc """
    Update the air pressure on the observation

    ## Examples

        iex> obs = Observation.new
        iex> obs |> air_pressure(989.0)
        %Observation{fields: %Observation.Fields{air_pressure: 989.0}}

  """
  def air_pressure(observation, value), do: field(observation, %{air_pressure: value})

  @doc """
    Update the sensor on the observation

    ## Examples

        iex> obs = Observation.new
        iex> obs |> sensor("hallway")
        %Observation{tags: %Observation.Tags{sensor: "hallway"}}

  """
  def sensor(observation, value), do: tag(observation, %{sensor: value})

  @doc """
    Update the timestamp to the current system time
  """
  def timestamp(observation), do: timestamp(observation, :os.system_time(:seconds))

  @doc """
    Update the timestamp on the observation

    ## Examples

        iex> obs = Observation.new
        iex> obs |> timestamp(123456)
        %Observation{timestamp: 123456}

  """
  def timestamp(observation, value) when is_integer(value), do: %{observation | timestamp: value}

  @doc """
    Updates a field on the observation

    ## Examples

        iex> obs = Observation.new
        iex> obs |> field(%{temperature: 1.0})
        %Observation{fields: %Observation.Fields{temperature: 1.0}}
  """
  def field(observation, value), do: %{observation | fields: Map.merge(observation.fields, value)}

  @doc """
    Updates a tag on the observation

    ## Examples

        iex> obs = Observation.new
        iex> obs |> tag(%{sensor: "test"})
        %Observation{tags: %Observation.Tags{sensor: "test"}}
  """
  def tag(observation, value), do: %{observation | tags: Map.merge(observation.tags, value)}

  @doc """
    Save the observation to InfluxDB
  """
  def save(observation), do: Connection.write(observation, precision: :seconds)
end
