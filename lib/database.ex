defmodule EctoCsv.Database do
  # Automatically defines child_spec/1
  use DynamicSupervisor

  alias EctoCsv.Table

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @spec start_child(path :: String.t(), format :: :csv | :tsv) ::
          DynamicSupervisor.on_start_child()
  def start_child(path, format) do
    # If MyWorker is not using the new child specs, we need to pass a map:
    # spec = %{id: MyWorker, start: {MyWorker, :start_link, [foo, bar, baz]}}
    spec = {Table, [path: path, format: format]}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
