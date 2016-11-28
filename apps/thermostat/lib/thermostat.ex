defmodule Thermos.Thermostat do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      Thermos.Thermostat.Influx.Connection.child_spec,
      supervisor(Thermos.Thermostat.Setpoint.Supervisor, []),
      supervisor(Thermos.Thermostat.Outside.Supervisor, []),
      supervisor(Thermos.Thermostat.Inside.Supervisor, []),
      supervisor(Thermos.Thermostat.Controller.Supervisor, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Thermos.Thermostat.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
