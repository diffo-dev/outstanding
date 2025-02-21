defmodule Outstanding.ListTest do
  use ExUnit.Case
  use Outstand

  gen_something_outstanding_test("element outstanding", [:a, :b], [:b, :c])
  gen_nothing_outstanding_test("realized", [:a, :b], [:a, :b])
  gen_nothing_outstanding_test("realized, out of order", [:a, :b], [:b, :a])
  gen_nothing_outstanding_test("realized, extra item", [:a, :b], [:a, :b, :c])
  gen_result_outstanding_test("element result", [:a, :b], [:b, :c], [:a])
end
