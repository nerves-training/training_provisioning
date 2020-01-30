defmodule ProvisioningUI.Scene.Idle do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph
  alias Scenic.ViewPort
  alias ProvisioningUI.LowLevel

  import Scenic.Primitives
  # import Scenic.Components

  @text_size 8

  @doc """
  Start this by passing  to display.

  ```
  ViewPort.set_root(viewport, {ProvisioningUI.Scene.NotSetup, "Unprovisioned"})
  ```
  """

  @impl true
  def init(_, _opts) do
    ScenicFontPressStart2p.load()

    graph =
      Graph.build(font: ScenicFontPressStart2p.hash(), font_size: @text_size)
      |> add_specs_to_graph([
        text_spec(message(), translate: {0, 10})
      ])

    {:ok,
     %{
       graph: graph
     }, push: graph}
  end

  @impl true
  def handle_input({:key, {"A", :press, 0}}, context, state) do
    ViewPort.set_root(context.viewport, {ProvisioningUI.Scene.Wizard, nil})
    {:noreply, state}
  end

  def handle_input(_event, _context, state) do
    # _ = Logger.info("Received event: #{inspect(event)}")
    {:noreply, state}
  end

  defp message() do
    """
    #{LowLevel.impl().serial_number()}

    Press #5
    for WiFi wizard
    """
  end
end
