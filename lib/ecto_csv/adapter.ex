defmodule EctoCsv.Adapter do
  @behaviour Ecto.Adapter

  @impl Ecto.Adapter
  def ensure_all_started(_config, type) do
    Application.ensure_all_started(:ecto_csv, type)
  end

  def init(config) do
    log = Keyword.get(config, :log, :debug)
    telemetry_prefix = Keyword.fetch!(config, :telemetry_prefix)
    telemetry = {config[:repo], log, telemetry_prefix ++ [:query]}

    #   config = adapter_config(config)
    #   opts = Keyword.take(config, @pool_opts)
    #   meta = %{telemetry: telemetry, sql: connection, opts: opts}
    #   {:ok, connection.child_spec(config), meta}
  end
end
