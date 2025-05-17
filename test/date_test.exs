defmodule Outstanding.DateTest do
  use ExUnit.Case
  use Outstand

  @now DateTime.utc_now() |> DateTime.to_naive()
  @future DateTime.utc_now() |> DateTime.add(1, :day) |> DateTime.to_date()
  @past DateTime.utc_now() |> DateTime.add(-1, :day) |> DateTime.to_date()

  gen_something_outstanding_test("value outstanding, future", @now, @future)
  gen_something_outstanding_test("value outstanding, past", @now, @past)
  gen_something_outstanding_test("value outstanding, nil", @now, nil)
  gen_nothing_outstanding_test("realized", @now, @now)
  gen_result_outstanding_test("value result, future", @now, @future, @now)
  gen_result_outstanding_test("value result, past", @now, @past, @now)
  gen_result_outstanding_test("value result, nil", @now, nil, @now)
end
