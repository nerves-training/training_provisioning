defmodule Starter.Scene.Home do
  use Scenic.Scene

  alias Scenic.Graph

  import Scenic.Primitives

  def init(_, _) do
    ScenicFontPressStart2p.load()

    graph =
      Graph.build(font: ScenicFontPressStart2p.hash(), font_size: 8)
      |> text(message(), fill: :white, translate: {0, 20})

    push_graph(graph)
    {:ok, graph}
  end

  defp message() do
    {:ok, i2c} = ATECC508A.Transport.I2C.init([])
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
      "Has aux cert"
    else
      "No aux cert"
    end
  end
end
