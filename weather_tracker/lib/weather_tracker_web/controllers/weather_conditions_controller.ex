defmodule WeatherTrackerWeb.WeatherConditionsController do
  use WeatherTrackerWeb, :controller

  require Logger

  alias WeatherTracker.{
    WeatherConditions,
    WeatherContitions.WeatherCondition
  }

  def create(conn, params) do
    IO.inspect(params)

    case WeatherConditions.create_entry(params) do
      {:ok, weather_condition = %WeatherCondition{}} ->
        Logger.debug("Created a weather condition entry")
        conn |> put_status(:created) |> json(weather_condition)
      error ->
        Logger.warn("Faled to create a weather entrty: #{inspect(error)}")
        conn |> put_status(:unprocessable_entity) |> json(%{message: "Poorly formatted payload"})
    end
  end
end
