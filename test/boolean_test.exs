defmodule Outstanding.BooleanTest do
  use ExUnit.Case
  use Outstand

  gen_something_outstanding_test("value outstanding", true, false)
  gen_something_outstanding_test("value outstanding, string", true, "a")
  gen_something_outstanding_test("value outstanding, nil", true, nil)
  gen_nothing_outstanding_test("realized true", true, true)
  gen_nothing_outstanding_test("realized false", false, false)
  gen_result_outstanding_test("false value result", false, true, false)
  gen_result_outstanding_test("true value result", true, false, true)
  gen_result_outstanding_test("value result, string", true, "a", true)
  gen_result_outstanding_test("value result, nil", true, nil, true)
end
