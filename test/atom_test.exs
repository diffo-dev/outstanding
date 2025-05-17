defmodule Outstanding.AtomTest do
  use ExUnit.Case
  use Outstand

  gen_something_outstanding_test("value outstanding", :a, :b)
  gen_something_outstanding_test("value outstanding, nil", :a, nil)
  gen_nothing_outstanding_test("realized", :a, :a)
  gen_nothing_outstanding_test("nil realized", nil, nil)
  gen_nothing_outstanding_test("nil realized by atom", nil, :a)
  gen_nothing_outstanding_test("nil realized by string", nil, "a")
  gen_result_outstanding_test("value result", :a, :b, :a)
  gen_result_outstanding_test("value result, nil", :a, nil, :a)

  # explicit_nil using atom rather than function
  gen_something_outstanding_test("explicit_nil value outstanding", :explicit_nil, true)
  gen_something_outstanding_test("explicit_nil value outstanding, regular nil", :explicit_nil, nil)
  gen_nothing_outstanding_test("explicit_nil realized", :explicit_nil, :explicit_nil)
  gen_result_outstanding_test("explicit_nil value result", :explicit_nil, true, :explicit_nil)
  gen_result_outstanding_test("explicit_nil value result, regular nil", :explicit_nil, nil, :explicit_nil)

  # no_value atom
  gen_nothing_outstanding_test("no value realized", :no_value, :no_value)
  gen_nothing_outstanding_test("no value realized by nil", :no_value, nil)
end
