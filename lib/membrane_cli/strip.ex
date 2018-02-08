defmodule Membrane.CLI.Strip do
  @moduledoc """
  Module containing helper functions for stripping unnecessary prefixes
  from module names.
  """


  @doc """
  Strips the Elixir. prefix from the module name and returns the remaining 
  string.
  """
  @spec strip_elixir_prefix(atom) :: String.t
  def strip_elixir_prefix(module) do
    << "Elixir.", rest :: binary >> = to_string(module)
    rest
  end


  @doc """
  Strips the Elixir.Membrane.Element prefix from the module name and returns 
  the remaining string.
  """
  @spec strip_membrane_element_prefix(atom) :: String.t
  def strip_membrane_element_prefix(module) do
    << "Elixir.Membrane.Element.", rest :: binary >> = to_string(module)
    rest
  end
end