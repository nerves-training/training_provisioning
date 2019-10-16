defmodule Starter.MixProject do
  use Mix.Project

  @app :starter
  @version "0.1.0"
  @all_targets [:rpi0, :rpi3a]

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.9",
      archives: [nerves_bootstrap: "~> 1.6"],
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps(),
      dialyzer: dialyzer(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
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
      {:nerves, "~> 1.5.0", runtime: false},
      {:shoehorn, "~> 0.6"},
      {:ring_logger, "~> 0.6"},
      {:toolshed, "~> 0.2"},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},

      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.6", targets: @all_targets},
      {:nerves_init_gadget, "~> 0.4", targets: @all_targets},
      {:nerves_time, "~> 0.1", targets: @all_targets},
      {:nerves_key, "~> 0.1", targets: @all_targets},
      {:scenic, "~> 0.10.0", targets: @all_targets},
      {:scenic_driver_oled_bonnet,
       github: "nerves-training/scenic_driver_oled_bonnet", targets: @all_targets},
      {:ssd1306, github: "nerves-training/ssd1306", targets: @all_targets},
      {:scenic_font_press_start_2p,
       github: "nerves-training/scenic_font_press_start_2p", targets: @all_targets},

      # Dependencies for first hands-on segment of training
      {:circuits_gpio, "~> 0.4", targets: @all_targets},
      {:circuits_i2c, "~> 0.3", targets: @all_targets},

      # Dependencies for specific targets
      {:nerves_system_rpi0, "~> 1.8", runtime: false, targets: :rpi0},
      {:nerves_system_rpi3a, "~> 1.8", runtime: false, targets: :rpi3a}
    ]
  end

  def release do
    [
      overwrite: true,
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod
    ]
  end

  defp dialyzer() do
    [
      flags: [:race_conditions, :unmatched_returns, :error_handling, :underspecs]
    ]
  end
end
