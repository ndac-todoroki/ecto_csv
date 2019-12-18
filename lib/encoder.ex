defmodule EctoCsv.Encoder do
  @spec as_string(any) :: {:ok, String.t()}
  def as_string(value), do: {:ok, to_string(value)}

  @spec from_boolean(boolean) :: {:ok, String.t()}
  def from_boolean(true), do: {:ok, "TRUE"}
  def from_boolean(false), do: {:ok, "FALSE"}
end
