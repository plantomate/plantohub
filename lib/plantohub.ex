defmodule Plantohub do
  @moduledoc """
  Documentation for Plantohub.
  """

  require Logger

  alias Circuits.GPIO

  @output_pin 18

  @doc """
  Hello world.

  ## Examples

      iex> Plantohub.hello
      :world

  """
  def click do
    Logger.info("Starting pin #{@output_pin} as output")
    {:ok, output_gpio} = GPIO.open(@output_pin, :output)
    # Circuits.GPIO.set_pull_mode(output_gpio, :pulldown)
    GPIO.write(output_gpio, 1)
    spawn(fn -> toggle_pin_forever(output_gpio) end)
  end


  defp toggle_pin_forever(output_gpio) do
    Logger.debug("Turning pin #{@output_pin} ON")
    GPIO.write(output_gpio, 0)
    Process.sleep(Enum.random(10..1000))

    Logger.debug("Turning pin #{@output_pin} OFF")
    GPIO.write(output_gpio, 1)
    Process.sleep(Enum.random(10..1000))

    toggle_pin_forever(output_gpio)
  end
end
