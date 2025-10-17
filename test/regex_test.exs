# SPDX-FileCopyrightText: 2025 outstanding contributors <https://github.com/diffo-dev/outstanding/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defmodule Outstanding.RegexTest do
  use ExUnit.Case
  use Outstand

  gen_something_outstanding_test("value outstanding", ~r/foo/, "bar")
  gen_nothing_outstanding_test("realized", ~r/foo/, "foo")
  gen_nothing_outstanding_test("realized, match within string", ~r/foo/, "barfoobar")
  gen_nothing_outstanding_test("realized, match within String.Chars implementation", ~r/foo/, :barfoobar)

  test "value result" do
    foo_regex = ~r/foo/
    outstanding = foo_regex --- "bar"
    assert outstanding == foo_regex
  end
end
