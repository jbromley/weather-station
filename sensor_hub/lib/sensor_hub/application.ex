defmodule SensorHub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias SensorHub.Sensor

  @impl true
  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SensorHub.Supervisor]

    children = children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: SensorHub.Worker.start_link(arg)
      # {SensorHub.Worker, arg},
    ]
  end

  def children(_target) do
    # The sensors will fail on the host, so let's only start them on
    # target devices.
    [
      {SGP30, []},
      {SGP40, [name: SGP40]},
      {BMP280, [i2c_address: 0x77, name: BMP280]},
      {VEML7700, %{}},
      {Finch, name: WeatherTrackerClient},
      {
        Publisher,
        %{sensors: sensors(),
          weather_tracker_url: weather_tracker_url()
        }
      }
    ]
  end

  defp sensors do
    [Sensor.new(SGP30), Sensor.new(SGP40), Sensor.new(BMP280), Sensor.new(VEML7700)]
  end

  defp weather_tracker_url do
    Application.get_env(:sensor_hub, :weather_tracker_url)
  end

  def target() do
    Application.get_env(:sensor_hub, :target)
  end
end
