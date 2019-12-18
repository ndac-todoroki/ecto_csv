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
    table_name = query.from |> parse_from_expr()

    table = Database.child_process(table_name)
    list = table |> Table.stream() |> Enum.to_list()

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
    table_name = query.from |> parse_from_expr()

    table = Database.child_process(table_name)
    table |> Table.stream()
  end

  def stream(_, _, {_, {:update_all, _, _, _, _}}, _, _), do: write_not_supported!()
  def stream(_, _, {_, {:delete_all, _, _, _, _}}, _, _), do: write_not_supported!()

  @spec parse_from_expr(any) :: String.t()
  defp parse_from_expr(nil), do: raise("no from given")
  defp parse_from_expr(%Ecto.Query.FromExpr{source: {table_name, _schema}}), do: table_name
end
