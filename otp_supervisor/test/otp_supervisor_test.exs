defmodule OtpSupervisorTest do
  use ExUnit.Case
  doctest OtpSupervisor

  test "greets the world" do
    assert OtpSupervisor.hello() == :world
  end
end
