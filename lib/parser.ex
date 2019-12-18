defmodule EctoCsv.Parser do
  alias NimbleCSV.RFC4180, as: CsvParser
  NimbleCSV.define(TsvParser, separator: "\t", escape: "\"")

  @type t :: CsvParser | TsvParser

  def select(:csv), do: {:ok, CsvParser}
  def select(:tsv), do: {:ok, TsvParser}
  def select(_), do: :error
end
