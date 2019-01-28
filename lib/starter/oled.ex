defmodule Starter.OLED do
  use GenServer

  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    {:ok, i2c} = Circuits.I2C.open("i2c-1")
    {:ok, cap} = RpiFbCapture.start_link(width: 128, height: 64, display: 0)

    SSD1306.init(i2c)

    send(self(), :capture)

    {:ok, %{i2c: i2c, cap: cap, last_crc: -1}}
  end

  @impl true
  def handle_info(:capture, state) do
    {:ok, frame} = RpiFbCapture.capture(state.cap, :mono_column_scan)

    crc = :erlang.crc32(frame.data)

    if crc != state.last_crc do
      SSD1306.display(state.i2c, frame.data)
    end

    Process.send_after(self(), :capture, 50)
    {:noreply, %{state | last_crc: crc}}
  end
end
