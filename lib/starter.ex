defmodule Starter do
  @moduledoc """
  Base app for NervesTeam training
  """

  @doc """
  Helper for provisioning or resetting a NervesKey for class
  """
  @spec provision(String.t()) :: :ok
  def provision(cert_name \\ "nerveskey_prod_signer2") do
    {:ok, i2c} = ATECC508A.Transport.I2C.init([])

    if NervesKey.provisioned?(i2c) do
      NervesKey.clear_aux_certificates(i2c)
    else
      provision_info = NervesKey.default_info(i2c)
      signer_cert = File.read!("/tmp/#{cert_name}.cert") |> X509.Certificate.from_pem!()
      signer_key = File.read!("/tmp/#{cert_name}.key") |> X509.PrivateKey.from_pem!()
      NervesKey.provision(i2c, provision_info, signer_cert, signer_key)
    end
  end
end
