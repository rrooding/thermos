defmodule Thermos.Thermostat.Controller.Hysteresis do
  @hysteresis 0.5

  @doc """
    Indicates if we should be heating, uses hysteresis band to prevent
    switching on and off too quickly

    ## Examples

        iex> heating?(false, 18.0, 20.0)
        true
        iex> heating?(false, 19.4, 20.0)
        true
        iex> heating?(false, 19.5, 20.0)
        false
        iex> heating?(false, 20.5, 20.0)
        false
        iex> heating?(false, 20.6, 20.0)
        false

        iex> heating?(true, 18.0, 20.0)
        true
        iex> heating?(true, 19.5, 20.0)
        true
        iex> heating?(true, 20.0, 20.0)
        true
        iex> heating?(true, 20.5, 20.0)
        true
        iex> heating?(true, 20.6, 20.0)
        false
  """
  def heating?(current_state, indoor, setpoint) do
    cond do
      indoor < low_band(setpoint)  -> true
      indoor > high_band(setpoint) -> false
      true                         -> current_state
    end
  end

  defp high_band(setpoint), do: setpoint + @hysteresis

  defp low_band(setpoint), do: setpoint - @hysteresis
end
