defmodule Outstanding.MapTest do
  use ExUnit.Case
  use Outstand

  gen_something_outstanding_test("key outstanding", %{x: :a, y: :b}, %{x: :a, z: :b})
  gen_something_outstanding_test("value outstanding", %{x: :a, y: :b}, %{x: :b, y: :b})
  gen_something_outstanding_test("key nil value outstanding", %{x: :a, y: nil}, %{x: :a, z: :b})
  gen_something_outstanding_test("value falsy outstanding",  %{x: false, y: :b}, %{x: :b, y: :b})
  gen_nothing_outstanding_test("realized", %{x: :a, y: :b}, %{x: :a, y: :b})
  gen_nothing_outstanding_test("realized with extra item", %{x: :a, y: :b}, %{x: :a, y: :b, z: :b})
  gen_result_outstanding_test("key result", %{x: :a, y: :b}, %{x: :a, z: :b}, %{y: :b})
  gen_result_outstanding_test("value result", %{x: :a, y: :b}, %{x: :b, y: :b}, %{x: :a})
  gen_result_outstanding_test("key nil result", %{x: :a, y: nil}, %{x: :a, z: :b}, %{y: nil})
  gen_result_outstanding_test("value falsy result", %{x: false, y: :b}, %{x: :b, y: :b}, %{x: false})
end
