defmodule Membrane.CLITest do
  use ExUnit.Case
  doctest Membrane.CLI

  test "greets the world" do
    assert Membrane.CLI.hello() == :world
  end
end
