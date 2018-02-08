defmodule Mix.Tasks.Membrane.Element.Inspect do
  use Mix.Task

  alias Membrane.CLI.Strip
  alias Membrane.CLI.Loader

  @shortdoc "Inspects given Membrane Element."

  @moduledoc """
  Inspects given Membrane Element.
  """

  @prefix "Elixir.Membrane.Element."

  @spec run(OptionParser.argv) :: :ok
  def run(argv) do
    {_opts, args} = OptionParser.parse!(argv)
    
    case args do
      [] ->
        Mix.raise("You have to pass Membrane Element name as an argument. You can use mix membrane.element.list to list installed Elements.")

      [element_name] when is_binary(element_name) ->
        modules_found = 
          Loader.load_elements(:code.get_path())
          |> Enum.reject(fn(module) ->
            case to_string(module) do
              << @prefix, ^element_name :: binary >> ->
                false

              _ ->
                true
            end
          end)

        case modules_found do
          [] ->
            Mix.raise("Unable to find Membrane Element \"#{element_name}\". You can use mix membrane.element.list to list installed Elements.")

          [element_module] ->
            print_console(element_module)
        end

      other ->
        Mix.raise("You have to pass single argument which is a Membrane Element name, given: #{inspect(other)}.")
    end
  end


  defp print_console(element_module) do
    element_module
    |> print_console_header("General Information")
    |> print_console_information
    |> print_console_header("Version")
    # TODO version
    |> print_console_header("Options")
    # TODO options
    |> print_console_header("Pads")
    |> print_console_source_pads
    |> print_console_sink_pads
  end


  defp print_console_header(element_module, header) do
    IO.puts(String.upcase(header))
    IO.puts(String.duplicate("=", String.length(header)))
    IO.puts("")

    element_module
  end


  defp print_console_information(element_module) do
    IO.puts(" * Name: #{Strip.strip_membrane_element_prefix(element_module)}")
    IO.puts(" * Module name: #{Strip.strip_elixir_prefix(element_module)}")
    IO.puts("")

    element_module
  end


  defp print_console_source_pads(element_module) do
    if function_exported?(element_module, :known_source_pads, 0) do
      IO.puts("Source:\n")

      element_module.known_source_pads
      |> Enum.each(fn({pad_name, {availability, mode, caps}}) ->
        IO.puts(" * #{inspect(pad_name)}")

        # TODO handle others
        case availability do
          :always ->
            IO.puts "   - Availability: always"
        end

        case mode do
          {:pull, _config} ->
            IO.puts "   - Mode: pull"
        end

        case caps do
          :any ->
            IO.puts "   - Caps: any"
        end
      end)

    else
      IO.puts("Source: none")
    end

    IO.puts("")
    element_module
  end


  defp print_console_sink_pads(element_module) do
    if function_exported?(element_module, :known_sink_pads, 0) do
      IO.puts("Sink:\n")

      element_module.known_sink_pads
      |> Enum.each(fn({pad_name, {availability, mode, caps}}) ->
        IO.puts(" * #{inspect(pad_name)}")

        # TODO handle others
        case availability do
          :always ->
            IO.puts "   - Availability: always"
        end

        case mode do
          {:pull, _config} ->
            IO.puts "   - Mode: pull"
        end

        case caps do
          :any ->
            IO.puts "   - Caps: any"
        end
      end)

    else
      IO.puts("Sink: none")
    end

    IO.puts("")
    element_module
  end
end