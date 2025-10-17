# SPDX-FileCopyrightText: 2025 outstanding contributors <https://github.com/diffo-dev/outstanding/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defmodule Outstanding.FloatTest do
  use ExUnit.Case
  use Outstand

  gen_something_outstanding_test("value outstanding", 1.1, 2.1)
  gen_nothing_outstanding_test("realized", 1.1, 1.1)
  gen_nothing_outstanding_test("realized by integer", 1.0, 1)
  gen_result_outstanding_test("value result", 1.1, 2.1, 1.1)
end
