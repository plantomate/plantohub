defmodule Plantohub do
  @moduledoc """
  Documentation for Plantohub.
  """

  require Logger

  alias Circuits.GPIO

  # @output_pin 18
  @pump_pin 23
  @air_sensor_pin 18

  @doc """
  Hello world.

  ## Examples

      iex> Plantohub.hello
      :world

  """
  def water do
    Logger.debug("Turning pump ON")
    {:ok, pump_gpio} = GPIO.open(@pump_pin, :output, initial_value: 1)
    GPIO.write(pump_gpio, 0)
    Process.sleep(5000)
    Logger.debug("Turning pump OFF")
    GPIO.write(pump_gpio, 1)
    # spawn(fn -> toggle_pin_forever(output_gpio) end)
  end

  def probe_soil do
    {:ok, ref} = Circuits.SPI.open("spidev0.0")
    {:ok, <<_::size(12), counts::size(12)>>} = Circuits.SPI.transfer(ref, <<0x60, 0x00, 0x00>>)
    rel = counts / 4095 * 100
    Logger.info("Relative dryness is #{rel}%")
    # {:ok, output_gpio} = GPIO.open(@output_pin, :output)
    # Circuits.GPIO.set_pull_mode(output_gpio, :pulldown)
    # GPIO.write(output_gpio, 1)
    # spawn(fn -> toggle_pin_forever(output_gpio) end)
  end

  def probe_air do
    {:ok, humidity, temp} = NervesDHT.read(:dht22, @air_sensor_pin)
    Logger.info("Air temp: #{temp}C, humidity: #{humidity}%")
    # {:ok, output_gpio} = GPIO.open(@output_pin, :output)
    # Circuits.GPIO.set_pull_mode(output_gpio, :pulldown)
    # GPIO.write(output_gpio, 1)
    # spawn(fn -> toggle_pin_forever(output_gpio) end)
  end

  # defp toggle_pin_forever(output_gpio) do
  #   Logger.debug("Turning pin #{@output_pin} ON")
  #   GPIO.write(output_gpio, 0)
  #   Process.sleep(Enum.random(10..1000))

  #   Logger.debug("Turning pin #{@output_pin} OFF")
  #   GPIO.write(output_gpio, 1)
  #   Process.sleep(Enum.random(10..1000))

  #   toggle_pin_forever(output_gpio)
  # end
end
