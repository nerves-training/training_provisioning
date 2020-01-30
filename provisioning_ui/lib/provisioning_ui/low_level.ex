defmodule ProvisioningUI.LowLevel do
  @callback provisioning_state() :: :unprovisioned | :has_aux_cert | :no_aux_cert | :no_nerves_key

  @callback serial_number() :: String.t()

  @callback run_wizard(opts :: keyword()) :: :ok
  @callback stop_wizard() :: :ok
  @callback clear_aux_cert() :: :ok

  @spec impl() :: module()
  def impl() do
    Application.get_env(:provisioning_ui, :low_level)
  end
end
