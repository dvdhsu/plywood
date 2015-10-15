defmodule Melamine do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    initializers();

    children = [
      # Start the endpoint when the application starts
      supervisor(Melamine.Endpoint, []),
      # Start the Ecto repository
      worker(Melamine.Repo, []),
      # Here you could define other workers and supervisors as children
      # worker(Melamine.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Melamine.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Melamine.Endpoint.config_change(changed, removed)
    :ok
  end

  def initializers() do
    facebook_secret = Application.get_env :melamine, :facebook_secret
    Facebook.Config.appsecret facebook_secret

    facebook_graph_url = Application.get_env :melamine, :facebook_graph_url
    Facebook.Config.graph_url facebook_graph_url
  end
end
