defmodule Outstanding.BitStringTest do
  use ExUnit.Case
  use Outstand

  gen_something_outstanding_test("value outstanding", "a", "b")
  gen_nothing_outstanding_test("realized", "a", "a")
  gen_result_outstanding_test("value result", "a", "ab", "a")
end
