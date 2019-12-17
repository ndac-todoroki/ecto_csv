defmodule EctoCsv.Table do
  @moduledoc """
  A GenServer that holds a port to a readable file.
  """

  use GenServer

  defstruct [:format, :parser, :path, :parse_options]

  @type t :: %__MODULE__{
          format: :csv | :tsv,
          parser: EctoCsv.Parser.t(),
          path: String.t(),
          parse_options: Keyword.t()
        }

  @readonly_mode [:read]

  def start_link(opts \\ []) when is_list(opts) do
    with {:ok, path} <- opts |> Keyword.fetch(:path),
         {:ok, format} <- opts |> Keyword.fetch(:format),
         {:ok, parser} <- EctoCsv.Parser.select(format) do
      state = %__MODULE__{
        format: format,
        parser: parser,
        path: path,
        parse_options: [skip_headers: true]
      }

      GenServer.start_link(__MODULE__, state)
    end
  end

  @spec read(GenServer.name()) :: Enum.t()
  def read(pid), do: GenServer.call(pid, {:read})

  @spec stream(GenServer.name(), Keyword.t()) :: Enumerable.t()
  def stream(pid, opts), do: GenServer.call(pid, {:stream, opts})

  @impl GenServer
  @spec init(EctoCsv.Reader.t()) :: {:ok, EctoCsv.Reader.t()}
  def init(%__MODULE__{} = state), do: {:ok, state}

  @impl GenServer
  def handle_call({:stream, opts}, _from, %__MODULE__{} = state) do
    stream =
      File.stream!(state.path, opts ++ @readonly_mode, :line)
      |> state.parser.parse_stream(state.parse_options)

    {:reply, stream, state}
  end

  @impl GenServer
  def handle_call({:read}, _from, %__MODULE__{} = state) do
    stream =
      File.read!(state.path)
      |> state.parser.parse_enumerable(state.parse_options)

    {:reply, stream, state}
  end
end
