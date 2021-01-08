defmodule MishkaDatabaseTest do
  use ExUnit.Case
  doctest MishkaDatabase

  test "greets the world" do
    assert MishkaDatabase.hello() == :world
  end
end
