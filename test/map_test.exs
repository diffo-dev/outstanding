defmodule Outstanding.MapTest do
  use ExUnit.Case
  use Outstand

  gen_something_outstanding_test("key outstanding", %{x: :a, y: :b}, %{x: :a, z: :b})
  gen_something_outstanding_test("value outstanding", %{x: :a, y: :b}, %{x: :b, y: :b})
  gen_something_outstanding_test("key explicit nil value outstanding, no value", %{x: :a, y: &Outstand.explicit_nil/1}, %{x: :a, z: :b})
  gen_something_outstanding_test("key explicit nil value outstanding, not nil", %{x: :a, y: &Outstand.explicit_nil/1}, %{x: :a, y: :c, z: :b})
  gen_something_outstanding_test("value falsy outstanding",  %{x: false, y: :b}, %{x: :b, y: :b})
  gen_something_outstanding_test("no value outstanding",  %{x: :no_value, y: :b}, %{x: :b, y: :b})
  gen_nothing_outstanding_test("realized", %{x: :a, y: :b}, %{x: :a, y: :b})
  gen_nothing_outstanding_test("realized with extra item", %{x: :a, y: :b}, %{x: :a, y: :b, z: :b})
  gen_nothing_outstanding_test("no value realized, nil value", %{x: :no_value, y: :b}, %{x: nil, y: :b})
  gen_nothing_outstanding_test("no value realized, no key", %{x: :no_value, y: :b}, %{y: :b})
  gen_result_outstanding_test("key result", %{x: :a, y: :b}, %{x: :a, z: :b}, %{y: :b})
  gen_result_outstanding_test("value result", %{x: :a, y: :b}, %{x: :b, y: :b}, %{x: :a})
  gen_result_outstanding_test("key explicit nil result, no value", %{x: :a, y: &Outstand.explicit_nil/1}, %{x: :a, z: :b}, %{y: :explicit_nil})
  gen_result_outstanding_test("key explicit nil result, not nil", %{x: :a, y: &Outstand.explicit_nil/1}, %{x: :a, y: :c, z: :b}, %{y: :explicit_nil})
  gen_result_outstanding_test("value falsy result", %{x: false, y: :b}, %{x: :b, y: :b}, %{x: false})
  gen_result_outstanding_test("no value result",  %{x: :no_value, y: :b}, %{x: :b, y: :b}, %{x: :no_value})
end
