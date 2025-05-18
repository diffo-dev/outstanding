defmodule Outstanding.StructDeriveTest do
  use ExUnit.Case
  use Outstand

  @v0 :value0
  @v1 :value1
  @v2 :value2

  defmodule ABC do
    @derive Outstanding
    defstruct [:a, :b, :c]
  end

  gen_something_outstanding_test("key outstanding", %ABC{a: @v0, b: @v1}, %ABC{a: @v0, c: @v1})
  gen_something_outstanding_test("value outstanding", %ABC{a: @v0, b: @v1, c: @v2}, %ABC{a: @v1, b: @v1, c: @v2})
  gen_nothing_outstanding_test("realized", %ABC{a: @v0, b: @v1, c: @v2}, %ABC{a: @v0, b: @v1, c: @v2})
  gen_nothing_outstanding_test("realized, no c expectation", %ABC{a: @v0, b: @v1}, %ABC{a: @v0, b: @v1})
  gen_nothing_outstanding_test("realized, nil c expectation", %ABC{a: @v0, b: @v1, c: nil}, %ABC{a: @v0, b: @v1})
  gen_nothing_outstanding_test("realized, extra item", %ABC{a: @v0, b: @v1}, %ABC{a: @v0, b: @v1, c: @v1})
  gen_result_outstanding_test("key result", %ABC{a: @v0, b: @v1}, %ABC{a: @v0, c: @v1}, %ABC{b: @v1})
  gen_result_outstanding_test("value result", %ABC{a: @v0, b: @v1}, %ABC{a: @v1, b: @v1}, %ABC{a: @v0})
end
