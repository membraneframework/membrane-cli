# Based on code of the Mix.Task module.

# Copyright 2012 Plataformatec

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#      http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

defmodule Membrane.CLI.Loader do
  @type element_module_t :: atom

  @prefix "Elixir.Membrane.Element."
  @prefix_size byte_size(@prefix)
  @suffix ".beam"
  @suffix_size byte_size(@suffix)

  @doc """
  Loads all elements in the given `paths`.
  """
  @spec load_elements([List.Chars.t()]) :: [element_module_t]
  def load_elements(dirs) do
    # We may get duplicate modules because we look through the
    # entire load path so make sure we only return unique modules.
    for dir <- dirs,
        file <- safe_list_dir(to_charlist(dir)),
        mod = element_from_path(file),
        uniq: true,
        do: mod
  end


  defp safe_list_dir(path) do
    case File.ls(path) do
      {:ok, paths} -> paths
      {:error, _} -> []
    end
  end


  defp element_from_path(filename) do
    base = Path.basename(filename)
    part = byte_size(base) - @prefix_size - @suffix_size

    case base do
      <<@prefix, rest::binary-size(part), @suffix>> ->
        mod = :"#{@prefix}#{rest}"
        ensure_element?(mod) && mod

      _ ->
        nil
    end
  end


  defp ensure_element?(module) do
    Code.ensure_loaded?(module) and 
      (function_exported?(module, :known_sink_pads, 0) or
      function_exported?(module, :known_soruce_pads, 0))
  end
end