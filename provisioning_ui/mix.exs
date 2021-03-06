defmodule ProvisioningUI.MixProject do
  use Mix.Project

  def project do
    [
      app: :provisioning_ui,
      version: "0.1.0",
      elixir: "~> 1.7",
      build_embedded: true,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {ProvisioningUI, []},
      extra_applications: [],
      env: [low_level: ProvisioningUI.Mock.LowLevel]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:scenic, "~> 0.10"},
      {:scenic_driver_glfw, "~> 0.10", targets: :host},
      {:scenic_font_press_start_2p, github: "nerves-training/scenic_font_press_start_2p"}
    ]
  end
end
