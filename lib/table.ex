defmodule EctoCsv.Table do
  @moduledoc """
  A GenServer that holds a port to a readable file.
  """

  use GenServer

  defstruct [:format, :parser, :path, :parse_options, :data]

  @type t :: %__MODULE__{
          format: :csv | :tsv,
          parser: EctoCsv.Parser.t(),
          path: String.t(),
          parse_options: Keyword.t(),
          data: String.t()
        }

  @doc """
  Parameter `name` should be a name to identify the table.
  This would be the GenServer's name, and thus unique among all tables.
  """
  def start_link(opts \\ []) when is_list(opts) do
    with {:ok, path} <- opts |> Keyword.fetch(:path),
         {:ok, format} <- opts |> Keyword.fetch(:format),
         {:ok, name} <- opts |> Keyword.fetch(:name),
         {:ok, parser} <- EctoCsv.Parser.select(format) do
      state = %__MODULE__{
        format: format,
        parser: parser,
        path: path,
        parse_options: [skip_headers: false],
        data: File.read!(path)
      }

      GenServer.start_link(__MODULE__, state, name: name)
    end
  end

  @spec read(GenServer.name()) :: Enum.t()
  def read(pid), do: GenServer.call(pid, :read)

  @spec stream(GenServer.name()) :: Enumerable.t()
  def stream(pid), do: GenServer.call(pid, :stream)

  #
  # GenServer implementations
  #

  @impl GenServer
  @spec init(EctoCsv.Reader.t()) :: {:ok, EctoCsv.Reader.t()}
  def init(%__MODULE__{} = state), do: {:ok, state}

  @impl GenServer
  def handle_call(:stream, _from, %__MODULE__{data: data} = state) do
    stream =
      data
      |> String.splitter("\n", trim: true)
      |> state.parser.parse_stream(state.parse_options)
      |> Stream.with_index(1)
      |> Stream.map(fn {data, index} -> {index, [data]} end)

    {:reply, stream, state}
  end

  @impl GenServer
  def handle_call(:read, _from, %__MODULE__{data: data} = state) do
    list =
      data
      |> String.splitter("\n", trim: true)
      |> state.parser.parse_stream(state.parse_options)

    {:reply, list, state}
  end
end
