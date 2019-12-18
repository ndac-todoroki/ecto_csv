defmodule EctoCsv.Adapter do
  @behaviour Ecto.Adapter

  @impl Ecto.Adapter
  defmacro __before_compile__(_env) do
    unquote(:ok)
  end

  @impl Ecto.Adapter
  def ensure_all_started(_config, type) do
    Application.ensure_all_started(:ecto_csv, type)
  end

  @impl Ecto.Adapter
  def init(_config) do
    {:ok, EctoCsv.Database.child_spec([]), adapter_meta()}
  end

  defp adapter_meta, do: %{}

  @doc """
  EctoCsv does not provide a pool, we just call the function.
  """
  @impl Ecto.Adapter
  def checkout(_adapter_meta, _config, function), do: function.()

  @impl Ecto.Adapter
  def loaders(:boolean, type), do: [&EctoCsv.Decorder.to_boolean/1, type]
  def loaders(:integer, type), do: [&EctoCsv.Decorder.to_integer/1, type]
  def loaders(:float, type), do: [&EctoCsv.Decorder.to_float/1, type]
  def loaders(:binary_id, type), do: [Ecto.UUID, type]
  def loaders(_others, type), do: [type]

  @impl Ecto.Adapter
  def dumpers(:boolean, type), do: [&EctoCsv.Encoder.from_boolean/1, type]
  def dumpers(:binary_id, type), do: [Ecto.UUID, type]
  def dumpers(_others, type), do: [&EctoCsv.Encoder.as_string/1, type]
end
