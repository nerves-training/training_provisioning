defmodule ProvisioningUI.Mock.LowLevel do
  @behaviour ProvisioningUI.LowLevel

  require Logger

  @impl true
  def provisioning_state() do
    # :no_nerves_key
    # :unprovisioned
    # :no_aux_cert
    :has_aux_cert
  end

  @impl true
  def clear_aux_cert() do
    _ = Logger.info("Clearing aux certificate!")
    :ok
  end

  @impl true
  def serial_number() do
    "1234567890"
  end

  @impl true
  def run_wizard(opts) do
    _ = Logger.info("Running the wizard with #{inspect(opts)}!")

    case Keyword.get(opts, :on_exit) do
      {m, f, a} ->
        spawn(fn ->
          Process.sleep(5000)
          apply(m, f, a)
        end)

      _ ->
        :ok
    end
  end

  @impl true
  def stop_wizard() do
    _ = Logger.info("Stopping the wizard!")
    :ok
  end
end
