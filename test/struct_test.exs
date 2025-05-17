defmodule Outstanding.StructTest do
  use ExUnit.Case
  use Outstand

  @v0 :value0
  @v1 :value1
  @v2 :value2

  defmodule XYZ do
    defstruct [:x, :y, :z]
  end

  defoutstanding expected :: XYZ, actual :: Any do
    case {expected, actual} do
      {nil, nil} ->
        nil

      {_, ^expected} ->
        nil

      {%name{}, %name{}} ->
        expected
        |> Map.from_struct()
        |> Outstanding.outstanding(Map.from_struct(actual))
        |> Outstand.map_to_struct(name)

      {_, _} ->
        # not an exact match so default to outstanding
        expected
    end
  end

  gen_something_outstanding_test("key outstanding", %XYZ{x: @v0, y: @v1}, %XYZ{x: @v0, z: @v1})
  gen_something_outstanding_test("value outstanding", %XYZ{x: @v0, y: @v1, z: @v2}, %XYZ{x: @v1, y: @v1, z: @v2})
  gen_nothing_outstanding_test("realized", %XYZ{x: @v0, y: @v1, z: @v2}, %XYZ{x: @v0, y: @v1, z: @v2})
  gen_nothing_outstanding_test("realized, no z expectation", %XYZ{x: @v0, y: @v1}, %XYZ{x: @v0, y: @v1})
  gen_nothing_outstanding_test("realized, nil z expectation", %XYZ{x: @v0, y: @v1, z: nil}, %XYZ{x: @v0, y: @v1})
  gen_nothing_outstanding_test("realized, extra item", %XYZ{x: @v0, y: @v1}, %XYZ{x: @v0, y: @v1, z: @v1})
  gen_result_outstanding_test("key result", %XYZ{x: @v0, y: @v1}, %XYZ{x: @v0, z: @v1}, %XYZ{y: @v1})
  gen_result_outstanding_test("value result", %XYZ{x: @v0, y: @v1}, %XYZ{x: @v1, y: @v1}, %XYZ{x: @v0})
end
