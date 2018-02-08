defmodule Mix.Tasks.Membrane.Element.List do
  use Mix.Task

  alias Membrane.CLI.Loader
  alias Membrane.CLI.Strip

  @shortdoc "Lists all installed Membrane Elements."

  @moduledoc """
  Lists all installed Membrane Elements.
  """


  @spec run(OptionParser.argv) :: :ok
  def run(_argv) do
    modules = Loader.load_elements(:code.get_path())

    print_console(modules)
  end


  defp print_console(modules) do
    modules
    |> Enum.map(fn(module) ->
      Strip.strip_membrane_element_prefix(module)
    end)
    |> Enum.sort
    |> Enum.each(fn(module) ->
      IO.puts(module)
      # TODO add description
    end)
  end
end