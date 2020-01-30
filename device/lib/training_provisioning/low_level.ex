defmodule TrainingProvisioning.LowLevel do
  @behaviour ProvisioningUI.LowLevel

  require Logger

  @impl true
  def provisioning_state() do
    {:ok, i2c} = ATECC508A.Transport.I2C.init([])

    cond do
      not NervesKey.detected?(i2c) ->
        :no_nerves_key

      not NervesKey.provisioned?(i2c) ->
        :unprovisioned

      NervesKey.has_aux_certificates?(i2c) ->
        :has_aux_cert

      true ->
        :no_aux_cert
    end
  end

  @impl true
  def clear_aux_cert() do
    {:ok, i2c} = ATECC508A.Transport.I2C.init([])
    NervesKey.clear_aux_certificates(i2c)
  end

  @impl true
  def serial_number() do
    {:ok, i2c} = ATECC508A.Transport.I2C.init([])
    NervesKey.manufacturer_sn(i2c)
  end

  @impl true
  def run_wizard(opts) do
    VintageNetWizard.run_wizard(opts)
  end

  @impl true
  def stop_wizard() do
    VintageNetWizard.stop_wizard()
  end
end
