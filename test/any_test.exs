defmodule Outstanding.AnyTest do
  use ExUnit.Case
  use Outstand

  # todo try with string values
  @v0 :value0
  @v1 :value1

  defmodule XY do
    defstruct [:x, :y]
  end

  defmodule XZ do
    defstruct [:x, :z]
  end

  defmodule XYZ do
    defstruct [:x, :y, :z]
  end

  gen_something_outstanding_test("key outstanding", %XYZ{x: @v0, y: @v1}, %XYZ{x: @v0, z: @v1})
  gen_something_outstanding_test("value outstanding", %XY{x: @v0, y: @v1}, %XY{x: @v1, y: @v1})
  gen_nothing_outstanding_test("realized", %XY{x: @v0, y: @v1}, %XY{x: @v0, y: @v1})
  gen_nothing_outstanding_test("realized, extra item", %XYZ{x: @v0, y: @v1}, %XYZ{x: @v0, y: @v1, z: @v1})
  gen_result_outstanding_test("key result", %XYZ{x: @v0, y: @v1}, %XYZ{x: @v0, z: @v1}, %XYZ{y: @v1})
  gen_result_outstanding_test("value result", %XY{x: @v0, y: @v1}, %XY{x: @v1, y: @v1}, %XY{x: @v0})
end
