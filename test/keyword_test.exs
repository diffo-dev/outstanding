# SPDX-FileCopyrightText: 2025 outstanding contributors <https://github.com/diffo-dev/outstanding/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defmodule Outstanding.KeywordTest do
  use ExUnit.Case
  use Outstand

  gen_something_outstanding_test("key outstanding", [a: :a, b: :b], a: :a, c: :c)
  gen_something_outstanding_test("value outstanding", [a: :a, b: :b], a: :a, b: :a)
  gen_something_outstanding_test("explicit nil value outstanding", [a: &Outstand.explicit_nil/1, b: :b], a: :a, b: :b)
  gen_something_outstanding_test("falsy value outstanding", [a: false, b: :b], a: :a, b: :b)
  gen_something_outstanding_test("no value outstanding", [a: :no_value, b: :b], a: :a, b: :b)
  gen_nothing_outstanding_test("realized", [a: :a, b: :b], a: :a, b: :b)
  gen_nothing_outstanding_test("nil realized, any value", [a: nil, b: :b], a: :a, b: :b)
  gen_nothing_outstanding_test("nil realized, nil value", [a: nil, b: :b], a: nil, b: :b)
  gen_nothing_outstanding_test("no value realized, nil value", [a: :no_value, b: :b], a: nil, b: :b)
  gen_nothing_outstanding_test("no value realized, no key", [a: :no_value, b: :b], b: :b)
  gen_result_outstanding_test("key result", [a: :a, b: :b], [a: :a, c: :c], b: :b)
  gen_result_outstanding_test("value result", [a: :a, b: :b], [a: :a, b: :a], b: :b)
  gen_result_outstanding_test("explicit nil value result", [a: &Outstand.explicit_nil/1, b: :b], [a: :a, b: :b], a: :explicit_nil)
  gen_result_outstanding_test("falsy value result", [a: false, b: :b], [a: :a, b: :b], a: false)
  gen_result_outstanding_test("no value result", [a: :no_value, b: :b], [a: :a, b: :b], a: :no_value)
end
