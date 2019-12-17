defmodule EctoCsv.Adapter.Schema do
@behaviour Ecto.Adapter.Schema
  import EctoCsv.Common.Exception

  def autogenerate(_), do: write_not_supported!()


end
