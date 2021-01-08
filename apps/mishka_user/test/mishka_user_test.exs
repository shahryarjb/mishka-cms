defmodule MishkaUserTest do
  use ExUnit.Case
  doctest MishkaUser

  test "greets the world" do
    assert MishkaUser.hello() == :world
  end
end
