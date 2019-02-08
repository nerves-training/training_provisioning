defmodule Starter.MixProject do
  use Mix.Project

  @all_targets [:rpi0, :rpi3a]

  def project do
    [
      app: :starter,
      version: "0.1.0",
      elixir: "~> 1.8",
      archives: [nerves_bootstrap: "~> 1.4"],
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.target() != :host,
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps()
    ]
  end

  # Starting nerves_bootstrap adds the required aliases to Mix.Project.config()
  # Aliases are only added if MIX_TARGET is set.
  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Starter.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.4", runtime: false},
      {:shoehorn, "~> 0.4"},
      {:ring_logger, "~> 0.6"},
      {:toolshed, "~> 0.2"},

      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.6", targets: @all_targets},
      {:nerves_init_gadget, "~> 0.4", targets: @all_targets},
      {:nerves_time, "~> 0.1", targets: @all_targets},
      {:nerves_key, "~> 0.1", targets: @all_targets},
      {:scenic, "~> 0.9"},
      {:scenic_driver_nerves_rpi, "~> 0.9", targets: @all_targets},
      {:ssd1306, github: "nerves-training/ssd1306", targets: @all_targets},
      {:scenic_font_press_start_2p,
       github: "nerves-training/scenic_font_press_start_2p", targets: @all_targets},
      {:rpi_fb_capture, "~> 0.1", targets: @all_targets},
      {:circuits_gpio, "~> 0.3", targets: @all_targets},

      # Dependencies for specific targets
      {:nerves_system_rpi0, "~> 1.6", runtime: false, targets: :rpi0},
      {:nerves_system_rpi3a, "~> 1.6", runtime: false, targets: :rpi3a}
    ]
  end
end
