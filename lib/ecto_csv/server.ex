defmodule EctoCsv.Server do
  @moduledoc """
  Each connection will have one EctoCsv.Server.
  One EctoCsv.Server has many children, each for one file.
  """

  use Application

  def start(_type, _args) do
    children = []
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
