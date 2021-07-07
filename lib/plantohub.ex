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
    {:ok, ref} = Circuits.SPI.open("spidev0.0", mode: 0, )
    {:ok, <<_::size(12), counts::size(12)>>} = Circuits.SPI.transfer(ref, <<0b00000110, 0b01000000, 0x00>>)
    rel = 100 - map_range(counts, {1400, 3700}, {0, 100})
    vol = counts / 4096 * 3.3
    Logger.info("Counts: #{counts}")
    Logger.info("Relative humidity: #{rel}%")
    Logger.info("Voltage: #{vol}V")
  end

  defp map_range(x, {in_min, in_max}, {out_min, out_max}) do
    (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
  end

  def probe_air do
    {:ok, humidity, temp} = NervesDHT.read(:dht22, @air_sensor_pin)
    Logger.info("Air temp: #{temp}C, humidity: #{humidity}%")
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
