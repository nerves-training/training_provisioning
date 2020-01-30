defmodule ProvisioningUI.Scene.NotSetup do
  use Scenic.Scene

  alias Scenic.Graph

  import Scenic.Primitives

  @moduledoc """
  This is a terminal UI state for boards that don't have a NervesKey or it
  hasn't been provisioned.
  """
  @text_size 8

  @doc """
  Start this by passing a message to display.

  ```
  ViewPort.set_root(viewport, {ProvisioningUI.Scene.NotSetup, "Unprovisioned"})
  ```
  """
  @impl true
  def init(message, _opts) do
    ScenicFontPressStart2p.load()

    graph =
      Graph.build(font: ScenicFontPressStart2p.hash(), font_size: @text_size)
      |> add_specs_to_graph([
        text_spec(message, translate: {20, 10})
      ])

    {:ok, :no_state, push: graph}
  end
end
