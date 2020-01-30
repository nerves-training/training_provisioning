defmodule TrainingProvisioning.Scene.Home do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph

  import Scenic.Primitives

  def init(_, _opts) do
    ScenicFontPressStart2p.load()

    {:ok, i2c} = ATECC508A.Transport.I2C.init([])

    graph =
      Graph.build(font: ScenicFontPressStart2p.hash(), font_size: 8)
      |> text(message(i2c), id: :message, fill: :white, translate: {0, 20})

    state = %{i2c: i2c, graph: graph}

    {:ok, state, push: graph}
  end

  def handle_input({:key, {"S", :press, 0}}, _context, %{i2c: i2c, graph: graph} = state) do
    if NervesKey.detected?(i2c) do
      _ = Logger.debug("Clearing out the aux certificates")
      NervesKey.clear_aux_certificates(i2c)

      new_graph =
        graph
        |> Graph.modify(:message, &text(&1, message(i2c)))

      new_state = %{state | graph: new_graph}

      {:noreply, new_state, push: new_graph}
    else
      {:noreply, state}
    end
  end

  def handle_input({:key, {" ", :press, 0}}, _context, state) do
    _ = VintageNetWizard.run_wizard()
    {:noreply, state}
  end

  def handle_input(_other, _context, state) do
    {:noreply, state}
  end

  defp message(i2c) do
    if NervesKey.detected?(i2c) do
      "#{serial_number(i2c)}\n#{aux_key(i2c)}"
    else
      "No ATECC508A"
    end
  end

  defp serial_number(transport) do
    if NervesKey.provisioned?(transport) do
      NervesKey.manufacturer_sn(transport)
    else
      "Unprovisioned"
    end
  end

  defp aux_key(transport) do
    if NervesKey.has_aux_certificates?(transport) do
      "Has aux cert\n\nPress the #6\nbutton to clear"
    else
      "No aux cert\n\nPress joystick\nfor WiFi wizard"
    end
  end
end
