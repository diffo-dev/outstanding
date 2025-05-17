defmodule Outstanding.MapOfMapTest do
  use ExUnit.Case
  use Outstand

  gen_something_outstanding_test("key outstanding", %{x: %{a: "a"}, y: %{b: "b"}}, %{x: %{a: "a"}, z: %{b: "b"}})
  gen_something_outstanding_test("value outstanding", %{x: %{a: "a"}, y: %{b: "b"}}, %{x: %{b: "b"}, y: %{b: "b"}})
  gen_nothing_outstanding_test("realized", %{x: %{a: "a"}, y: %{b: "b"}}, %{x: %{a: "a"}, y: %{b: "b"}})
  gen_nothing_outstanding_test("realized with extra item", %{x: %{a: "a"}, y: %{b: "b"}}, %{x: %{a: "a"}, y: %{b: "b"}, z: %{b: "b"}})

  gen_nothing_outstanding_test("realized with extra item in child map", %{x: %{a: "a"}, y: %{b: "b"}}, %{x: %{a: "a"}, y: %{b: "b", c: "c"}})

  gen_result_outstanding_test("key result", %{x: %{a: "a"}, y: %{b: "b"}}, %{x: %{a: "a"}, z: %{b: "b"}}, %{y: %{b: "b"}})
  gen_result_outstanding_test("value result", %{x: %{a: "a"}, y: %{b: "b"}}, %{x: %{b: "b"}, y: %{b: "b"}}, %{x: %{a: "a"}})
end
