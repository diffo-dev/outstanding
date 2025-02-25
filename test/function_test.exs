defmodule Outstanding.FunctionTest do
  use ExUnit.Case
  use Outstand

  gen_something_outstanding_test("any_atom value outstanding", &Outstand.any_atom/1, "a")
  gen_nothing_outstanding_test("any_atom realized", &Outstand.any_atom/1, :a)
  gen_nothing_outstanding_test("any_atom nil realized", &Outstand.any_atom/1, nil)
  gen_result_outstanding_test("any_atom value result", &Outstand.any_atom/1, "a", :any_atom)

  gen_something_outstanding_test("any_bitstring value outstanding", &Outstand.any_bitstring/1, nil)
  gen_nothing_outstanding_test("any_bitstring realized", &Outstand.any_bitstring/1, "aa")
  gen_result_outstanding_test("any_bitstring value result", &Outstand.any_bitstring/1, nil, :any_bitstring)

  gen_something_outstanding_test("any_boolean value outstanding", &Outstand.any_boolean/1, nil)
  gen_nothing_outstanding_test("any_boolean realized", &Outstand.any_boolean/1, true)
  gen_result_outstanding_test("any_boolean value result", &Outstand.any_boolean/1, nil, :any_boolean)

  gen_something_outstanding_test("any_float value outstanding", &Outstand.any_float/1, 1)
  gen_nothing_outstanding_test("any_float realized", &Outstand.any_float/1, 1.1)
  gen_result_outstanding_test("any_float value result", &Outstand.any_float/1, 1, :any_float)

  gen_something_outstanding_test("any_integer value outstanding", &Outstand.any_integer/1, 1.1)
  gen_nothing_outstanding_test("any_integer realized", &Outstand.any_integer/1, 1)
  gen_result_outstanding_test("any_integer value result", &Outstand.any_integer/1, 1.1, :any_integer)

  gen_something_outstanding_test("any_list value outstanding", &Outstand.any_list/1, {:a, :b, :c})
  gen_nothing_outstanding_test("any_list realized", &Outstand.any_list/1, [:a])
  gen_nothing_outstanding_test("any_list empty realized", &Outstand.any_list/1, [])
  gen_result_outstanding_test("any_list value result", &Outstand.any_list/1, {:a, :b, :c}, :any_list)

  gen_something_outstanding_test("any_map value outstanding", &Outstand.any_map/1, [:a])
  gen_nothing_outstanding_test("any_map realized", &Outstand.any_map/1, %{a: :a})
  gen_nothing_outstanding_test("any_map empty realized", &Outstand.any_map/1, %{})
  gen_result_outstanding_test("any_map value result", &Outstand.any_map/1, [:a], :any_map)

  gen_something_outstanding_test("any_map_set value outstanding", &Outstand.any_map_set/1, [:a])
  gen_nothing_outstanding_test("any_map_set realized", &Outstand.any_map_set/1, MapSet.new([:a]))
  gen_nothing_outstanding_test("any_map_set empty realized", &Outstand.any_map_set/1, MapSet.new())
  gen_result_outstanding_test("any_map_set value result", &Outstand.any_map_set/1, [:a], :any_map_set)

  gen_something_outstanding_test("any_number value outstanding", &Outstand.any_number/1, "10")
  gen_nothing_outstanding_test("any_number integer realized", &Outstand.any_number/1, 10)
  gen_nothing_outstanding_test("any_number float realized", &Outstand.any_number/1, 10.1)
  gen_result_outstanding_test("any_number value result", &Outstand.any_number/1, "10", :any_number)

  gen_something_outstanding_test("any_range value outstanding", &Outstand.any_range/1, 10)
  gen_nothing_outstanding_test("any_range realized", &Outstand.any_range/1, 1..10)
  gen_result_outstanding_test("any_range value result", &Outstand.any_range/1, 10, :any_range)

  gen_something_outstanding_test("any_tuple value outstanding", &Outstand.any_tuple/1, [:a])
  gen_nothing_outstanding_test("any_tuple realized", &Outstand.any_tuple/1, {:a, :b, :c})
  gen_result_outstanding_test("any_tuple value result", &Outstand.any_tuple/1, [:a], :any_tuple)

  gen_something_outstanding_test("empty_list value outstanding", &Outstand.empty_list/1, [:a])
  gen_nothing_outstanding_test("empty_list realized", &Outstand.empty_list/1, [])
  gen_result_outstanding_test("empty_list value result", &Outstand.empty_list/1, [:a], :empty_list)

  gen_something_outstanding_test("empty_map value outstanding", &Outstand.empty_map/1, %{a: :a})
  gen_nothing_outstanding_test("empty_map realized", &Outstand.empty_map/1, %{})
  gen_result_outstanding_test("empty_map value result", &Outstand.empty_map/1, %{a: :a}, :empty_map)

  gen_something_outstanding_test("empty_map_set value outstanding", &Outstand.empty_map_set/1, MapSet.new([:a]))
  gen_nothing_outstanding_test("empty_map_set realized", &Outstand.empty_map_set/1, MapSet.new())
  gen_result_outstanding_test("empty_map_set value result", &Outstand.empty_map_set/1, MapSet.new([:a]), :empty_map_set)

  gen_something_outstanding_test("explicit_nil value outstanding", &Outstand.explicit_nil/1, true)
  gen_nothing_outstanding_test("explicit_nil realized", &Outstand.explicit_nil/1, nil)
  gen_result_outstanding_test("explicit_nil value result", &Outstand.explicit_nil/1, true, :explicit_nil)

  gen_something_outstanding_test("non_empty_list value outstanding", &Outstand.non_empty_map/1, [])
  gen_nothing_outstanding_test("non_empty_list realized", &Outstand.non_empty_list/1, [:a])
  gen_result_outstanding_test("non_empty_list value result", &Outstand.non_empty_list/1, [], :non_empty_list)

  gen_something_outstanding_test("non_empty_map value outstanding", &Outstand.non_empty_map/1, %{})
  gen_nothing_outstanding_test("non_empty_map realized", &Outstand.non_empty_map/1, %{a: :a})
  gen_result_outstanding_test("non_empty_map value result", &Outstand.non_empty_map/1, %{}, :non_empty_map)

  gen_something_outstanding_test("non_empty_map_set value outstanding", &Outstand.non_empty_map_set/1, MapSet.new())
  gen_nothing_outstanding_test("non_empty_map_set realized", &Outstand.non_empty_map_set/1, MapSet.new([:a]))
  gen_result_outstanding_test("non_empty_map_set value result", &Outstand.non_empty_map_set/1, MapSet.new(), :non_empty_map_set)
end
