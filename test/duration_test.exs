defmodule Outstanding.DurationTest do
  use ExUnit.Case
  use Outstand

  @year Duration.new!(year: 1)
  @hour Duration.new!(hour: 1)
  @minute Duration.new!(minute: 1)
  @sixty_seconds Duration.new!(second: 60)
  @second Duration.new!(second: 1)

  gen_something_outstanding_test("value outstanding, shorter", @minute, @second)
  gen_something_outstanding_test("value outstanding, longer", @minute, @hour)
  gen_something_outstanding_test("value outstanding, nil", @minute, nil)
  gen_something_outstanding_test("value outstanding, large", @minute, @year)
  gen_nothing_outstanding_test("realized", @minute, @minute)
  gen_nothing_outstanding_test("realized, equivalent", @minute, @sixty_seconds)
  gen_result_outstanding_test("value result, shorter", @minute, @second, @minute)
  gen_result_outstanding_test("value result, longer", @minute, @hour, @minute)
  gen_result_outstanding_test("value result, nil", @minute, nil, @minute)
  gen_result_outstanding_test("value result, large", @minute, @year, @minute)
end
