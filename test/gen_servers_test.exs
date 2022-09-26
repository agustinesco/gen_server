defmodule GenServersTest do
  use ExUnit.Case
  doctest GenServers

  test "greets the world" do
    assert GenServers.hello() == :world
  end
end
