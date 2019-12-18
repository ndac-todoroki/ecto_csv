defmodule EctoCsv.Database do
  # Automatically defines child_spec/1
  use DynamicSupervisor

  @registry Database.TablesRegistry

  alias EctoCsv.Table

  def start_link(init_arg) do
    Registry.start_link(keys: :unique, name: @registry)
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @spec start_child(path :: String.t(), format :: :csv | :tsv, name :: String.t()) ::
          DynamicSupervisor.on_start_child()
  def start_child(path, format, name) do
    opts = [path: path, format: format, name: child_process(name)]
    spec = {Table, opts}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  # :via tupleをつくる
  def child_process(name), do: {:via, Registry, {@registry, name}}
end
