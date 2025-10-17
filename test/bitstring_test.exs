# SPDX-FileCopyrightText: 2025 outstanding contributors <https://github.com/diffo-dev/outstanding/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defmodule Outstanding.BitStringTest do
  use ExUnit.Case
  use Outstand

  gen_something_outstanding_test("value outstanding", "a", "b")
  gen_something_outstanding_test("value outstanding, nil", "a", nil)
  gen_nothing_outstanding_test("realized", "a", "a")
  gen_result_outstanding_test("value result", "a", "b", "a")
  gen_result_outstanding_test("value result, nil", "a", nil, "a")
end
