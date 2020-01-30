defmodule ProvisioningUI.Scene.Wizard do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph
  alias Scenic.ViewPort
  alias ProvisioningUI.LowLevel

  import Scenic.Primitives
  # import Scenic.Components

  @text_size 8

  @impl true
  def init(_, opts) do
    ScenicFontPressStart2p.load()

    LowLevel.impl().run_wizard(on_exit: {Kernel, :send, [self(), :wizard_is_done]})

    graph =
      Graph.build(font: ScenicFontPressStart2p.hash(), font_size: @text_size)
      |> add_specs_to_graph([
        text_spec(message(), translate: {0, 20})
      ])

    {:ok, %{graph: graph, viewport: opts[:viewport]}, push: graph}
  end

  @impl true
  def handle_input({:key, {"S", :press, 0}}, context, state) do
    ViewPort.set_root(context.viewport, {ProvisioningUI.Scene.Idle, nil})

    LowLevel.impl().stop_wizard()

    {:noreply, state}
  end

  def handle_input(event, _context, state) do
    _ = Logger.info("Received event: #{inspect(event)}")
    {:noreply, state}
  end

  @impl true
  def handle_info(:wizard_is_done, state) do
    ViewPort.set_root(state.viewport, {ProvisioningUI.Scene.Idle, nil})
    {:noreply, state}
  end

  defp message() do
    """
    #{LowLevel.impl().serial_number()}

    Configuring WiFi
    Press the #6
    button to quit
    """
  end
end
