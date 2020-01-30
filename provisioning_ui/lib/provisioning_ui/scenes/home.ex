defmodule ProvisioningUI.Scene.Home do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph
  alias Scenic.ViewPort

  alias ProvisioningUI.LowLevel

  import Scenic.Primitives

  @text_size 8

  @impl true
  def init(_, opts) do
    ScenicFontPressStart2p.load()

    graph =
      Graph.build(font: ScenicFontPressStart2p.hash(), font_size: @text_size)
      |> add_specs_to_graph([
        text_spec("Initializing...", translate: {0, 20})
      ])

    Process.send_after(self(), :continue, 1000)

    {:ok, %{viewport: opts[:viewport]}, push: graph}
  end

  @impl true
  def handle_info(:continue, state) do
    case LowLevel.impl().provisioning_state() do
      :has_aux_cert ->
        ViewPort.set_root(state.viewport, {ProvisioningUI.Scene.HasAuxCert, nil})

      :no_aux_cert ->
        ViewPort.set_root(state.viewport, {ProvisioningUI.Scene.Idle, nil})

      :unprovisioned ->
        ViewPort.set_root(state.viewport, {ProvisioningUI.Scene.NotSetup, "Unprovisioned"})

      :no_nerves_key ->
        ViewPort.set_root(state.viewport, {ProvisioningUI.Scene.NotSetup, "No NervesKey!"})
    end

    {:noreply, state}
  end
end
