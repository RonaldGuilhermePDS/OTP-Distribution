defmodule OtpSupervisor.MixProject do
  use Mix.Project

  def project do
    [
      app: :otp_supervisor,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :wx, :observer],
      mod: {OtpSupervisor.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.16.1"},
      {:bandit, "~> 1.5.5"},
      {:jason, "~> 1.4.3"},
      {:libcluster, "~> 3.3.3"}
    ]
  end
end
