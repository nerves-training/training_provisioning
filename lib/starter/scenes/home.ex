defmodule Starter.Scene.Home do
  use Scenic.Scene

  alias Scenic.Graph

  import Scenic.Primitives

  def init(_, _) do
    Starter.PressStart2P.load()

    sn = serial_number()

    graph =
      Graph.build(font: Starter.PressStart2P.hash(), font_size: 8)
      |> text(sn, fill: :white, translate: {0, 20})

    push_graph(graph)
    {:ok, graph}
  end

  defp serial_number() do
    {:ok, i2c} = ATECC508A.Transport.I2C.init([])
    if NervesKey.provisioned?(i2c) do
      NervesKey.manufacturer_sn(i2c)
    else
      "unprovisioned"
    end
  end
end
