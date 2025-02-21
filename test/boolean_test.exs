defmodule Outstanding.BooleanTest do
  use ExUnit.Case
  use Outstand

  gen_something_outstanding_test("value outstanding", true, false)
  gen_nothing_outstanding_test("realized true", true, true)
  gen_nothing_outstanding_test("realized false", false, false)
  gen_result_outstanding_test("value result", false, nil, false)
end
