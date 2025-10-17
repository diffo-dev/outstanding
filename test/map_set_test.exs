# SPDX-FileCopyrightText: 2025 outstanding contributors <https://github.com/diffo-dev/outstanding/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defmodule Outstanding.MapSetTest do
  use ExUnit.Case
  use Outstand

  gen_something_outstanding_test("element outstanding", MapSet.new([:a, :b]), MapSet.new([:b, :c]))
  gen_nothing_outstanding_test("realized", MapSet.new([:a, :b]), MapSet.new([:a, :b]))
  gen_nothing_outstanding_test("realized, out of order", MapSet.new([:a, :b]), MapSet.new([:b, :a]))
  gen_nothing_outstanding_test("realized, extra item", MapSet.new([:a, :b]), MapSet.new([:a, :b, :c]))
  gen_result_outstanding_test("element result", MapSet.new([:a, :b]), MapSet.new([:b, :c]), MapSet.new([:a]))
end
