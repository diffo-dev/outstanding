defmodule Outstanding.StructDeriveExceptTest do
  use ExUnit.Case
  use Outstand

  @v0 :value0
  @v1 :value1

  defmodule AB do
    @derive {Outstanding, except: [:c]}
    defstruct [:a, :b, :c]
  end

  gen_something_outstanding_test("key outstanding", %AB{a: @v0, b: @v1}, %AB{a: @v0})
  gen_something_outstanding_test("value outstanding", %AB{a: @v0, b: @v1}, %AB{a: @v1, b: @v1})
  gen_nothing_outstanding_test("realized", %AB{a: @v0, b: @v1}, %AB{a: @v0, b: @v1})
  gen_nothing_outstanding_test("realized, extra item", %AB{a: @v0, b: @v1}, %AB{a: @v0, b: @v1, c: @v1})
  gen_result_outstanding_test("key result", %AB{a: @v0, b: @v1}, %AB{a: @v0}, %AB{b: @v1})
  gen_result_outstanding_test("value result", %AB{a: @v0, b: @v1}, %AB{a: @v1, b: @v1}, %AB{a: @v0})
end
