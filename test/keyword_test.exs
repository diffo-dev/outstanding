defmodule Outstanding.KeywordTest do
  use ExUnit.Case
  use Outstand

  gen_something_outstanding_test("key outstanding", [{:a, :a}, {:b, :b}], [{:a, :a}, {:c, :c}])
  gen_something_outstanding_test("value outstanding", [{:a, :a}, {:b, :b}], [{:a, :a}, {:a, :b}])
  gen_nothing_outstanding_test("realized", {:a, :a}, {:a, :a})
  gen_result_outstanding_test("key result", [{:a, :a}, {:b, :b}], [{:a, :a}, {:c, :c}], [{:b, :b}])
  gen_result_outstanding_test("value result", [{:a, :a}, {:b, :b}], [{:a, :a}, {:b, :a}], [{:b, :b}])
end
