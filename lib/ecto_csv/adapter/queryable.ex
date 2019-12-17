defmodule EctoCsv.Adapter.Queryable do
  @behaviour Ecto.Adapter.Queryable

  import EctoCsv.Common.Exception

  def prepare(
        operation,
        %Ecto.Query{from: {table, schema}, order_bys: order_bys, limit: limit} = query
      ) do
    fetch_id = fn map -> Map.fetch!(map, :id) end
    ordering_fn = fn list -> list |> Enum.sort_by(&fetch_id.(&1)) end
    limit = get_limit(limit)
    limit_fn = if limit == nil, do: & &1, else: &Enum.take(&1, limit)
    # context = Context.new(table, schema)
    context = :something
    {:nocache, {operation, query, {limit, limit_fn}, context, ordering_fn}}
  end

  # Extract limit from an `Ecto.Query`
  defp get_limit(nil), do: nil
  defp get_limit(%Ecto.Query.QueryExpr{expr: limit}), do: limit

  def execute(
        %{} = adapter_meta,
        %{select: term, preloads: term, sources: term} = query_meta,
        {:nocache, {:all, %Ecto.Query{} = query, {limit, limit_fn}, context, ordering_fn}},
        params,
        options
      ) do
    count = 0
    results = []
    {count, [results]}
  end

  def execute(_, _, {_, {:update_all, _, _, _, _}}, _, _), do: write_not_supported!()
  def execute(_, _, {_, {:delete_all, _, _, _, _}}, _, _), do: write_not_supported!()

  def stream(
        %{} = adapter_meta,
        %{select: term, preloads: term, sources: term} = query_meta,
        {:nocache, {:all, %Ecto.Query{} = query, {limit, limit_fn}, context, ordering_fn}},
        params,
        options
      ) do
    count = 0
    results = []
    {count, [results]}
  end

  def stream(_, _, {_, {:update_all, _, _, _, _}}, _, _), do: write_not_supported!()
  def stream(_, _, {_, {:delete_all, _, _, _, _}}, _, _), do: write_not_supported!()
end
