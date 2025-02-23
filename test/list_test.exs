defmodule Outstanding.ListTest do
  use ExUnit.Case
  use Outstand

  gen_something_outstanding_test("element outstanding", [:a, :b], [:b, :c])
  gen_something_outstanding_test("order outstanding", [:a, :b], [:b, :a])
  gen_something_outstanding_test("empty outstanding", [], [:a])
  gen_something_outstanding_test("extra outstanding", [:a, :b], [:a, :b, :c])
  gen_nothing_outstanding_test("realized", [:a, :b], [:a, :b])
  gen_nothing_outstanding_test("empty realized", [], [])
  gen_result_outstanding_test("element result", [:a, :b], [:b, :c], [:a, :b])
  gen_result_outstanding_test("order result", [:a, :b], [:b, :a], [:a, :b])
  gen_result_outstanding_test("empty result", [], [:a], [])
  gen_result_outstanding_test("extra result", [:a, :b], [:a, :b, :c], [:a, :b])
end
