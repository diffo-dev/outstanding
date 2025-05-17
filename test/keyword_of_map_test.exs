defmodule Outstanding.KeywordOfMapTest do
  use ExUnit.Case
  use Outstand

  gen_something_outstanding_test("key outstanding", [x: %{a: "a"}, y: %{b: "b"}], x: %{a: "a"}, z: %{b: "b"})
  gen_something_outstanding_test("value outstanding", [x: %{a: "a"}, y: %{b: "b"}], x: %{b: "b"}, y: %{b: "b"})
  gen_something_outstanding_test("nil value outstanding", [x: &Outstand.explicit_nil/1, y: %{b: "b"}], x: %{b: "b"}, y: %{b: "b"})
  gen_something_outstanding_test("falsy value outstanding", [x: false, y: %{b: "b"}], x: %{b: "b"}, y: %{b: "b"})
  gen_nothing_outstanding_test("realized", [x: %{a: "a"}, y: %{b: "b"}], x: %{a: "a"}, y: %{b: "b"})
  gen_nothing_outstanding_test("realized with extra item", [x: %{a: "a"}, y: %{b: "b"}], x: %{a: "a"}, y: %{b: "b"}, z: %{b: "b"})

  gen_nothing_outstanding_test("realized with extra item in child map", [x: %{a: "a"}, y: %{b: "b"}],
    x: %{a: "a"},
    y: %{b: "b"},
    z: %{b: "b", c: "c"}
  )

  gen_result_outstanding_test("key result", [x: %{a: "a"}, y: %{b: "b"}], [x: %{a: "a"}, z: %{b: "b"}], y: %{b: "b"})
  gen_result_outstanding_test("value result", [x: %{a: "a"}, y: %{b: "b"}], [x: %{b: "b"}, y: %{b: "b"}], x: %{a: "a"})

  gen_result_outstanding_test("nil value result", [x: &Outstand.explicit_nil/1, y: %{b: "b"}], [x: %{b: "b"}, y: %{b: "b"}],
    x: :explicit_nil
  )

  gen_result_outstanding_test("falsy value result", [x: false, y: %{b: "b"}], [x: %{b: "b"}, y: %{b: "b"}], x: false)
end
