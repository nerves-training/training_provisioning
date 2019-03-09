defmodule Starter.Scene.Home do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph

  import Scenic.Primitives

  def init(_, _) do
    ScenicFontPressStart2p.load()

    {:ok, i2c} = ATECC508A.Transport.I2C.init([])
    build_and_push_graph(i2c)

    {:ok, i2c}
  end

  def handle_input({:key, {"S", :press, 0}}, _context, i2c) do
    if NervesKey.detected?(i2c) do
      Logger.debug("Clearing out the aux certificates")
      NervesKey.clear_aux_certificates(i2c)
      build_and_push_graph(i2c)
    end

    {:noreply, i2c}
  end

  def handle_input(_other, _context, i2c) do
    {:noreply, i2c}
  end

  defp build_and_push_graph(i2c) do
    graph =
      Graph.build(font: ScenicFontPressStart2p.hash(), font_size: 8)
      |> text(message(i2c), fill: :white, translate: {0, 20})

    push_graph(graph)
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
      "No aux cert"
    end
  end
end
