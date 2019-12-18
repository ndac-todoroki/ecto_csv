defmodule EctoCsv.Adapter.Queryable do
  @behaviour Ecto.Adapter.Queryable

  alias EctoCsv.{Database, Table}

  import EctoCsv.Common.Exception

  @type operation :: :all | :update_all | :delete_all

  @impl Ecto.Adapter.Queryable
  @spec prepare(any, Ecto.Query.t()) :: {:nocache, {operation(), Ecto.Query.t()}}
  def prepare(operation, %Ecto.Query{} = query) do
    {:nocache, {operation, query}}
  end

  @impl Ecto.Adapter.Queryable
  def execute(
        %{} = _adapter_meta,
        %{} = _query_meta,
        {:nocache, {:all, %Ecto.Query{} = query}},
        _params,
        _options
      ) do
    # Schema module == nil だと死ぬ
    {_table_name, schema_module} = query.from |> parse_from_expr()
    %Database.Settings{} = settings = schema_module.table_settings

    table = Database.fetch_table(settings)
    list = table |> Table.read() |> Enum.to_list()

    {length(list), list}
  end

  def execute(_, _, {_, {:update_all, _, _, _, _}}, _, _), do: write_not_supported!()
  def execute(_, _, {_, {:delete_all, _, _, _, _}}, _, _), do: write_not_supported!()

  @impl Ecto.Adapter.Queryable
  def stream(
        %{} = _adapter_meta,
        %{} = _query_meta,
        {:nocache, {:all, %Ecto.Query{} = query}},
        _params,
        _options
      ) do
    # Schema module == nil だと死ぬ
    {_table_name, schema_module} = query.from |> parse_from_expr()
    %Database.Settings{} = settings = schema_module.table_settings

    table = Database.fetch_table(settings)
    table |> Table.stream()
  end

  def stream(_, _, {_, {:update_all, _, _, _, _}}, _, _), do: write_not_supported!()
  def stream(_, _, {_, {:delete_all, _, _, _, _}}, _, _), do: write_not_supported!()

  @spec parse_from_expr(any) :: {String.t(), module}
  defp parse_from_expr(nil), do: raise("no from given")

  defp parse_from_expr(%Ecto.Query.FromExpr{source: {table_name, schema}}),
    do: {table_name, schema}
end
