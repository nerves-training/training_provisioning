# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.

config :shoehorn,
  init: [:nerves_runtime, :nerves_init_gadget],
  app: Mix.Project.config()[:app]

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger]

# Authorize the device to receive firmware using your public key.
# See https://hexdocs.pm/nerves_firmware_ssh/readme.html for more information
# on configuring nerves_firmware_ssh.

config :nerves_firmware_ssh,
  authorized_keys: [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDT6lRp4wT80iA/GW2Vo+d37ytXGZ/e03h8znlPtwybn9k9ZDbx+EAc7jPNJmXsy7+lIpWGfYtBlgKZomEDYKI7HOSfQTtPS6mWRaHbP58lSkunLEL851kh3HO3/ikaC+TXZJEMtb+5NTJ+vwqg2ysrUlz1L91M0AQNk73eW+KLh/pSDsH5XCvVSWqrpMiHySL4IQV9eY+/4Q9Pq9D9vBk/jaSRXWhTUxo09IYxgVnYK2Sd9gxF97cM7mCQdj6A38bfMFrOZManlbGReUwpFoBWsIIDbGYvNBMsVQF7WLy0FGt4UGqYTZUppWZTEpkmiyMwPCVwBsfJtyXh1gQzU4iH nerves_training_id_rsa"
  ]

# Configure nerves_init_gadget.
# See https://hexdocs.pm/nerves_init_gadget/readme.html for more information.

# Setting the node_name will enable Erlang Distribution.
# Only enable this for prod if you understand the risks.
node_name = if Mix.env() != :prod, do: "starter"

config :nerves_init_gadget,
  ifname: "usb0",
  address_method: :dhcpd,
  mdns_domain: "nerves.local",
  node_name: node_name,
  node_host: :mdns_domain

config :starter, :viewport, %{
  name: :main_viewport,
  size: {128, 64},
  default_scene: {Starter.Scene.Home, nil},
  drivers: [
    %{
      module: Scenic.Driver.Nerves.Rpi
    },
    %{
      module: ScenicDriverGPIO,
      opts: [
        # Joystick press
        %{
          pin: 4,
          pull_mode: :pullup,
          low: {:key, {" ", :press, 0}},
          high: {:key, {" ", :release, 0}}
        },
        # Joystick up
        %{
          pin: 17,
          pull_mode: :pullup,
          low: {:key, {"up", :press, 0}},
          high: {:key, {"up", :release, 0}}
        },
        # Joystick right
        %{
          pin: 23,
          pull_mode: :pullup,
          low: {:key, {"right", :press, 0}},
          high: {:key, {"right", :release, 0}}
        },
        # Joystick down
        %{
          pin: 22,
          pull_mode: :pullup,
          low: {:key, {"down", :press, 0}},
          high: {:key, {"down", :release, 0}}
        },
        # Joystick left
        %{
          pin: 27,
          pull_mode: :pullup,
          low: {:key, {"left", :press, 0}},
          high: {:key, {"left", :release, 0}}
        },
        # #5
        %{
          pin: 5,
          pull_mode: :pullup,
          low: {:key, {"A", :press, 0}},
          high: {:key, {"A", :release, 0}}
        },
        # #6
        %{
          pin: 6,
          pull_mode: :pullup,
          low: {:key, {"S", :press, 0}},
          high: {:key, {"S", :release, 0}}
        }
      ]
    }
  ]
}

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.target()}.exs"
