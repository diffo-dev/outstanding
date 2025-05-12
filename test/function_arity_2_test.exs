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

  gen_something_outstanding_test("less_than value outstanding", {&Outstand.less_than/2, %Duration{hour: 1}}, %Duration{hour: 2})
  gen_something_outstanding_test("less_than value outstanding, equal", {&Outstand.less_than/2, %Duration{hour: 1}}, %Duration{hour: 1})
  gen_nothing_outstanding_test("less_than value realized", {&Outstand.less_than/2, %Duration{hour: 1}}, %Duration{minute: 59})
  gen_result_outstanding_test("less_than value result", {&Outstand.less_than/2, %Duration{hour: 1}}, %Duration{hour: 2}, :less_than)
  gen_result_outstanding_test("less_than value result, equal", {&Outstand.less_than/2, %Duration{hour: 1}}, %Duration{hour: 1}, :less_than)

  gen_something_outstanding_test("greater_than value outstanding", {&Outstand.greater_than/2, %Duration{hour: 2}}, %Duration{hour: 1})
  gen_something_outstanding_test("greater_than value outstanding, equal", {&Outstand.greater_than/2, %Duration{hour: 2}}, %Duration{hour: 2})
  gen_nothing_outstanding_test("greater_than value realized", {&Outstand.greater_than/2, %Duration{hour: 2}}, %Duration{minute: 121})
  gen_result_outstanding_test("greater_than value result", {&Outstand.greater_than/2, %Duration{hour: 2}}, %Duration{hour: 2}, :greater_than)
  gen_result_outstanding_test("greater_than value result, equal", {&Outstand.greater_than/2, %Duration{hour: 2}}, %Duration{hour: 2}, :greater_than)

  gen_something_outstanding_test("bounded_by value outstanding, low", {&Outstand.bounded_by/2, [%Duration{hour: 1}, %Duration{minute: 90}]}, %Duration{minute: 30})
  gen_something_outstanding_test("bounded_by value outstanding, high", {&Outstand.bounded_by/2, [%Duration{hour: 1}, %Duration{minute: 90}]}, %Duration{hour: 2})
  gen_nothing_outstanding_test("bounded_by value realized", {&Outstand.bounded_by/2, [%Duration{hour: 1}, %Duration{minute: 90}]}, %Duration{minute: 70})
  gen_nothing_outstanding_test("bounded_by value realized, lower_bound", {&Outstand.bounded_by/2, [%Duration{hour: 1}, %Duration{minute: 90}]}, %Duration{minute: 60})
  gen_nothing_outstanding_test("bounded_by value realized, upper_bound", {&Outstand.bounded_by/2, [%Duration{hour: 1}, %Duration{minute: 90}]}, %Duration{minute: 90})
  gen_result_outstanding_test("bounded_by value result, low", {&Outstand.bounded_by/2, [%Duration{hour: 1}, %Duration{minute: 90}]}, %Duration{minute: 30}, :bounded_by)
  gen_result_outstanding_test("bounded_by value result, high", {&Outstand.bounded_by/2, [%Duration{hour: 1}, %Duration{minute: 90}]}, %Duration{hour: 2}, :bounded_by)

  gen_something_outstanding_test("unbounded_by value outstanding", {&Outstand.unbounded_by/2, [%Duration{hour: 1}, %Duration{minute: 90}]}, %Duration{minute: 70})
  gen_something_outstanding_test("unbounded_by value outstanding, lower bound", {&Outstand.unbounded_by/2, [%Duration{hour: 1}, %Duration{minute: 90}]}, %Duration{minute: 60})
  gen_something_outstanding_test("unbounded_by value outstanding, high bound", {&Outstand.unbounded_by/2, [%Duration{hour: 1}, %Duration{minute: 90}]}, %Duration{minute: 90})
  gen_nothing_outstanding_test("unbounded_by value realized, low", {&Outstand.unbounded_by/2, [%Duration{hour: 1}, %Duration{minute: 90}]}, %Duration{minute: 30})
  gen_nothing_outstanding_test("unbounded_by value realized, high", {&Outstand.unbounded_by/2, [%Duration{hour: 1}, %Duration{minute: 90}]}, %Duration{minute: 100})
  gen_result_outstanding_test("unbounded_by value result", {&Outstand.unbounded_by/2, [%Duration{hour: 1}, %Duration{minute: 90}]}, %Duration{minute: 70}, :unbounded_by)
  gen_result_outstanding_test("unbounded_by value result, lower bound", {&Outstand.unbounded_by/2, [%Duration{hour: 1}, %Duration{minute: 90}]}, %Duration{minute: 60}, :unbounded_by)
  gen_result_outstanding_test("unbounded_by value result, high bound", {&Outstand.unbounded_by/2, [%Duration{hour: 1}, %Duration{minute: 90}]}, %Duration{minute: 90}, :unbounded_by)
end
