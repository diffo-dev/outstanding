defmodule Outstanding.RangeTest do
  use ExUnit.Case
  use Outstand

  gen_something_outstanding_test("value outstanding", 1..10, 1..11)
  gen_something_outstanding_test("value outstanding, out of range", 1..10, 11)
  gen_something_outstanding_test("value outstanding, stepped range", 0..20//5, 19)
  gen_nothing_outstanding_test("realized", 1..10, 1..10)
  gen_nothing_outstanding_test("realized by integer in range", 0..10, 5)
  gen_nothing_outstanding_test("realized by integer in stepped range", 0..100//20, 40)
  gen_result_outstanding_test("value result", 1..10, 1..11, 1..10)
  gen_result_outstanding_test("value result, out of range", 1..10, 11, 1..10)
  gen_result_outstanding_test("value result, stepped range", 0..20//5, 9, 0..20//5)
end
