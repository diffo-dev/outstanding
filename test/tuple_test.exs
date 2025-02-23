defmodule Outstanding.TupleTest do
  use ExUnit.Case
  use Outstand

  gen_something_outstanding_test("key outstanding", {:a, :a}, {:b, :a})
  gen_something_outstanding_test("value outstanding", {:a, :a}, {:a, :b})
  gen_nothing_outstanding_test("realized", {:a, :a}, {:a, :a})
  gen_result_outstanding_test("key result", {:a, :a}, {:b, :a}, {:a, :a})
  gen_result_outstanding_test("value result", {:a, :a}, {:a, :b}, {:a, :a})
end
