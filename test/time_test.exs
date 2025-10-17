# SPDX-FileCopyrightText: 2025 outstanding contributors <https://github.com/diffo-dev/outstanding/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defmodule Outstanding.TimeTest do
  use ExUnit.Case
  use Outstand

  @now DateTime.utc_now() |> DateTime.to_time()
  @future DateTime.utc_now() |> DateTime.add(1, :hour) |> DateTime.to_time()
  @past DateTime.utc_now() |> DateTime.add(-1, :hour) |> DateTime.to_time()

  gen_something_outstanding_test("value outstanding, future", @now, @future)
  gen_something_outstanding_test("value outstanding, past", @now, @past)
  gen_something_outstanding_test("value outstanding, nil", @now, nil)
  gen_nothing_outstanding_test("realized", @now, @now)
  gen_result_outstanding_test("value result, future", @now, @future, @now)
  gen_result_outstanding_test("value result, past", @now, @past, @now)
  gen_result_outstanding_test("value result, nil", @now, nil, @now)
end
