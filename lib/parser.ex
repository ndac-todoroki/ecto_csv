defmodule EctoCsv.Parser do
  alias NimbleCSV.RFC4180, as: CsvParser
  NimbleCSV.define(TsvParser, separator: "\t", escape: "\"")

  @type t :: CsvParser | TsvParser

  def select(:csv), do: {:ok, CsvParser}
  def select(:tsv), do: {:ok, TsvParser}
  def select(_), do: :error

  # defmodule StreamResult do
  #   defstruct headers: [], body: nil
  #
  #   @type t :: %__MODULE__{
  #           headers: [String.t()],
  #           body: File.Stream.t()
  #         }
  # end

  # defmodule ListResult do
  #   defstruct headers: [], body: nil
  #
  #   @type t :: %__MODULE__{
  #           headers: [String.t()],
  #           body: Enumerable.t()
  #         }
  # end
end
