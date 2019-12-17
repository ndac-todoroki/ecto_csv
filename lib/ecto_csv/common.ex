defmodule EctoCsv.Common do
  defmodule Exception do
    @spec write_not_supported! :: none
    def write_not_supported!, do: raise "EctoCsv is read-only"
  end
end
