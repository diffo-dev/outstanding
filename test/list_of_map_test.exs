defmodule Outstanding.ListOfMapTest do
  use ExUnit.Case
  use Outstand

  gen_something_outstanding_test("element outstanding", [%{a: "a"}, %{b: "b"}], [%{b: "b"}, %{c: "c"}])
  gen_something_outstanding_test("order outstanding", [%{a: "a"}, %{b: "b"}], [%{b: "b"}, %{a: "a"}])
  gen_something_outstanding_test("empty outstanding", [], [%{a: "a"}])
  gen_something_outstanding_test("extra outstanding", [%{a: "a"}, %{b: "b"}], [%{a: "a"}, %{b: "b"}, %{c: "c"}])
  gen_something_outstanding_test("missing outstanding", [%{a: "a"}, %{b: "b"}], [%{a: "a"}])
  gen_nothing_outstanding_test("realized", [%{a: "a"}, %{b: "b"}], [%{a: "a"}, %{b: "b"}])
  gen_nothing_outstanding_test("realised, extra elements in map", [%{a: "a"}, %{b: "b"}], [%{a: "a", c: "c"}, %{b: "b", d: "d"}])
  gen_nothing_outstanding_test("realized, empty", [], [])
  gen_result_outstanding_test("element result", [%{a: "a"}, %{b: "b"}], [%{b: "b"}, %{c: "c"}], [%{a: "a"}, %{b: "b"}])
  gen_result_outstanding_test("order result", [%{a: "a"}, %{b: "b"}], [%{b: "b"}, %{a: "a"}], [%{a: "a"}, %{b: "b"}])
  gen_result_outstanding_test("empty result", [], [%{a: "a"}], [])
  gen_result_outstanding_test("extra result", [%{a: "a"}, %{b: "b"}], [%{a: "a"}, %{b: "b"}, %{c: "c"}], [nil, nil])
  gen_result_outstanding_test("missing result", [%{a: "a"}, %{b: "b"}], [%{a: "a"}], [nil, %{b: "b"}])
end
