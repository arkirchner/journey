use Mix.Config

# Configure your database
config :journey, Journey.Repo,
  username: "postgres",
  password: "postgres",
  database: "journey_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :journey, JourneyWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :arc,
  storage: Arc.Storage.Local
