defmodule Thermos.Web.Instream.Observation do
  use Instream.Series

  series do
    database "thermos"
    measurement "observation"

    tag :sensor

    field :temperature
    field :relative_humidity
    field :air_pressure
  end
end
