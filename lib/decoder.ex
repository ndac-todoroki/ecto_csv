defmodule EctoCsv.Decorder do
  @doc """
  Tries to read string csv value as an integer.
  """
  @spec to_integer(String.t()) :: {:ok, integer} | :error
  def to_integer(value), do: value |> Integer.parse() |> do_to_integer()

  defp do_to_integer(:error), do: :error
  defp do_to_integer({value, ""}), do: {:ok, value}

  defp do_to_integer({value, "." <> digits}) do
    with {0, ""} <- Integer.parse(digits) do
      {:ok, value}
    else
      _ -> :error
    end
  end

  defp do_to_integer({_, _}), do: :error

  @doc """
  Tries to read string csv value as a float.
  """
  @spec to_float(String.t()) :: {:ok, float} | :error
  def to_float(value), do: value |> Float.parse() |> do_to_float()

  defp do_to_float(:error), do: :error
  defp do_to_float({value, ""}), do: {:ok, value}
  defp do_to_float({_, _}), do: :error

  @doc """
  Tries to read string csv value as a boolean.
  Value examples are: `TRUE` `true` `False` `false`
  """
  @spec to_boolean(String.t()) :: {:ok, boolean} | :error
  def to_boolean(value), do: value |> String.upcase() |> do_to_boolean()

  defp do_to_boolean("TRUE"), do: {:ok, true}
  defp do_to_boolean("FALSE"), do: {:ok, false}
  defp do_to_boolean(_), do: :error
end
