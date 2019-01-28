defmodule StarterTest do
  use ExUnit.Case
  doctest Starter

  test "greets the world" do
    assert Starter.hello() == :world
  end
end
