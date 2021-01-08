# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config



config :mishka_cms_web,
  generators: [context_app: :mishka_cms]

# Configures the endpoint
config :mishka_cms_web, MishkaCmsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "O+3pm3jde2YB9Xj/uRdEQ2qHzNoMSyYZseBL3O1fQUS29/HA5+KxgX4IwTdE34es",
  render_errors: [view: MishkaCmsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: MishkaCms.PubSub,
  live_view: [signing_salt: "9uhlsuP0"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
