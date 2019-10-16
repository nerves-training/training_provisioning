use Mix.Config

# Authorize the device to receive firmware using your public key.
# See https://hexdocs.pm/nerves_firmware_ssh/readme.html for more information
# on configuring nerves_firmware_ssh.

config :nerves_firmware_ssh,
  authorized_keys: [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDT6lRp4wT80iA/GW2Vo+d37ytXGZ/e03h8znlPtwybn9k9ZDbx+EAc7jPNJmXsy7+lIpWGfYtBlgKZomEDYKI7HOSfQTtPS6mWRaHbP58lSkunLEL851kh3HO3/ikaC+TXZJEMtb+5NTJ+vwqg2ysrUlz1L91M0AQNk73eW+KLh/pSDsH5XCvVSWqrpMiHySL4IQV9eY+/4Q9Pq9D9vBk/jaSRXWhTUxo09IYxgVnYK2Sd9gxF97cM7mCQdj6A38bfMFrOZManlbGReUwpFoBWsIIDbGYvNBMsVQF7WLy0FGt4UGqYTZUppWZTEpkmiyMwPCVwBsfJtyXh1gQzU4iH nerves_training_id_rsa"
  ]

config :vintage_net,
  regulatory_domain: "US",
  config: [
    {"usb0", %{type: VintageNet.Technology.Gadget}},
    {"eth0",
     %{
       type: VintageNet.Technology.Ethernet,
       ipv4: %{
         method: :dhcp
       }
     }},
    {"wlan0",
     %{
       type: VintageNet.Technology.WiFi
     }}
  ]

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.target()}.exs"
