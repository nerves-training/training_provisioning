defmodule ProvisioningUI.Scene.HasAuxCert do
  use Scenic.Scene

  require Logger

  alias Scenic.Graph
  alias Scenic.ViewPort

  alias ProvisioningUI.LowLevel

  import Scenic.Primitives

  @moduledoc """
  This page is shown when the Auxiliary key slot has been programmed.

  This usually needs to get cleared at the start of a training class, but
  we don't want to do it automatically.
  """
  @text_size 8

  @doc """
  """
  @impl true
  def init(_, _opts) do
    ScenicFontPressStart2p.load()
    # get the width and height of the viewport. This is to demonstrate creating
    # a transparent full-screen rectangle to catch user input
    # {:ok, %ViewPort.Status{size: {width, height}}} = ViewPort.info(opts[:viewport])

    graph =
      Graph.build(font: ScenicFontPressStart2p.hash(), font_size: @text_size)
      |> add_specs_to_graph([
        text_spec(message(), translate: {0, 20})
      ])

    {:ok,
     %{
       graph: graph
     }, push: graph}
  end

  @impl true
  def handle_input({:key, {"S", :press, 0}}, context, state) do
    LowLevel.impl().clear_aux_cert()
    ViewPort.set_root(context.viewport, {ProvisioningUI.Scene.Idle, nil})
    {:noreply, state}
  end

  def handle_input(event, _context, state) do
    _ = Logger.info("Received event: #{inspect(event)}")
    {:noreply, state}
  end

  defp message() do
    """
    #{LowLevel.impl().serial_number()}
    Has aux cert

    Press the #6
    button to clear
    """
  end
end
