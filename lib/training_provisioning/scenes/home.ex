defmodule TrainingProvisioning.Scene.Home do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph

  import Scenic.Primitives

  defmodule NervesKeyState do
    @moduledoc false
    defstruct detected: false,
              provisioned: false,
              serial_number: "",
              has_aux_cert: false
  end

  @impl true
  def init(_, _opts) do
    ScenicFontPressStart2p.load()

    {:ok, i2c} = ATECC508A.Transport.I2C.init([])

    nk_state = nerves_key_state(i2c)

    graph =
      Graph.build(font: ScenicFontPressStart2p.hash(), font_size: 8)
      |> text(message(:start, nk_state), id: :message, fill: :white, translate: {0, 20})

    state = %{i2c: i2c, nk_state: nk_state, graph: graph}

    {:ok, state, push: graph}
  end

  @impl true
  def handle_input({:key, {"S", :press, 0}}, _context, %{i2c: i2c, graph: graph} = state) do
    if NervesKey.detected?(i2c) do
      _ = Logger.debug("Clearing out the aux certificates")
      NervesKey.clear_aux_certificates(i2c)
      nk_state = nerves_key_state(i2c)

      new_graph =
        graph
        |> Graph.modify(:message, &text(&1, message(:start, nk_state)))

      new_state = %{state | nk_state: nk_state, graph: new_graph}

      {:noreply, new_state, push: new_graph}
    else
      {:noreply, state}
    end
  end

  def handle_input({:key, {" ", :press, 0}}, _context, %{i2c: _i2c, graph: graph} = state) do
    _ = VintageNetWizard.run_wizard(on_exit: {Kernel, :send, [self(), :the_wizard_is_done]})

    new_graph =
      graph
      |> Graph.modify(:message, &text(&1, message(:wizard, state.nk_state)))

    {:noreply, state, push: new_graph}
  end

  def handle_input(_other, _context, state) do
    {:noreply, state}
  end

  @impl true
  def handle_info(:the_wizard_is_done, %{i2c: _i2c, graph: graph} = state) do
    new_graph =
      graph
      |> Graph.modify(:message, &text(&1, message(:start, state.nk_state)))

    {:noreply, state, push: new_graph}
  end

  defp nerves_key_state(i2c) do
    cond do
      not NervesKey.detected?(i2c) ->
        %NervesKeyState{}

      not NervesKey.provisioned?(i2c) ->
        %NervesKeyState{detected: true}

      true ->
        %NervesKeyState{
          detected: true,
          provisioned: true,
          serial_number: NervesKey.manufacturer_sn(i2c),
          has_aux_cert: NervesKey.has_aux_certificates?(i2c)
        }
    end
  end

  defp message(_all_contexts, %NervesKeyState{detected: false}) do
    "No ATECC508A"
  end

  defp message(_all_contexts, %NervesKeyState{provisioned: false}) do
    "Unprovisioned"
  end

  defp message(:start, %NervesKeyState{has_aux_cert: true} = nk_state) do
    """
    #{nk_state.serial_number}
    Has aux cert

    Press the #6
    button to clear
    """
  end

  defp message(:start, %NervesKeyState{has_aux_cert: false} = nk_state) do
    """
    #{nk_state.serial_number}
    No aux cert

    Press joystick
    for WiFi wizard
    """
  end

  defp message(:wizard, nk_state) do
    """
    #{nk_state.serial_number}

    Wizard running!
    Look for AP.
    """
  end
end
