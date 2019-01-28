defmodule Starter do
  @moduledoc """
  Documentation for Starter.
  """

  @doc """
  Helper to provision the NervesKey
  """
  @spec provision(String.t()) :: :ok
  def provision(cert_name \\ "nerveskey_prod_signer2") do
    {:ok, i2c} = ATECC508A.Transport.I2C.init([])

    provision_info = NervesKey.default_info(i2c)

    signer_cert = File.read!("/tmp/#{cert_name}.cert") |> X509.Certificate.from_pem!()
    true
    signer_key = File.read!("/tmp/#{cert_name}.key") |> X509.PrivateKey.from_pem!()
    true

    NervesKey.provision(i2c, provision_info, signer_cert, signer_key)
  end
end
