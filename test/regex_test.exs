defmodule Outstanding.RegexTest do
  use ExUnit.Case
  use Outstand

  gen_something_outstanding_test("value outstanding", ~r/foo/, "bar")
  gen_nothing_outstanding_test("realized", ~r/foo/, "foo")
  gen_nothing_outstanding_test("realized, match within string", ~r/foo/, "barfoobar")
  gen_result_outstanding_test("value result", ~r/foo/, "bar", ~r/foo/)
end
