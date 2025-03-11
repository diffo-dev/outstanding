defmodule Outstanding.ExpectedFunctionArity2Test do
  use ExUnit.Case
  use Outstand

  gen_something_outstanding_test("all_of value outstanding", {&Outstand.all_of/2, [1, 2, 3]}, [2, 3])
  gen_nothing_outstanding_test("all_of value realized", {&Outstand.all_of/2, [1, 2, 3]}, [1, 2, 3])
  gen_nothing_outstanding_test("all_of value realized, extra element", {&Outstand.all_of/2, [1, 2, 3]}, [1, 2, 3, 4])
  gen_result_outstanding_test("all_of value result", {&Outstand.all_of/2, [1, 2, 3]}, [2, 3], :all_of)

  gen_something_outstanding_test("any_of value outstanding", {&Outstand.any_of/2, [1, 2, 3]}, 4)
  gen_nothing_outstanding_test("any_of value realized", {&Outstand.any_of/2, [1, 2, 3]}, 3)
  gen_nothing_outstanding_test("any_of value realized, duplicates", {&Outstand.any_of/2, [1, 2, 2]}, 2)
  gen_result_outstanding_test("any_of value result", {&Outstand.any_of/2, [1, 2, 3]}, 4, :any_of)

  gen_something_outstanding_test("none_of value outstanding", {&Outstand.none_of/2, [1, 2, 3]}, 3)
  gen_something_outstanding_test("none_of value outstanding, duplicates", {&Outstand.none_of/2, [1, 2, 2]}, 2)
  gen_nothing_outstanding_test("none_of value realized", {&Outstand.none_of/2, [1, 2, 3]}, 4)
  gen_result_outstanding_test("none_of value result", {&Outstand.none_of/2, [1, 2, 3]}, 3, :none_of)
  gen_result_outstanding_test("none_of value result, duplicates", {&Outstand.none_of/2, [1, 2, 2]}, 2, :none_of)

  gen_something_outstanding_test("one_of value outstanding", {&Outstand.one_of/2, [1, 2, 3]}, 4)
  gen_something_outstanding_test("one_of value outstanding, duplicates", {&Outstand.one_of/2, [1, 2, 2]}, 2)
  gen_nothing_outstanding_test("one_of value realized", {&Outstand.one_of/2, [1, 2, 3]}, 3)
  gen_result_outstanding_test("one_of value result", {&Outstand.one_of/2, [1, 2, 3]}, 4, :one_of)
  gen_result_outstanding_test("one_of value result, duplicates", {&Outstand.one_of/2, [1, 2, 2]}, 2, :one_of)
end
