defmodule Outstanding.FunctionTest do
  use ExUnit.Case
  use Outstand
  require Integer

  gen_something_outstanding_test("any_atom value outstanding", &Outstand.any_atom/1, "a")
  gen_nothing_outstanding_test("any_atom realized", &Outstand.any_atom/1, :a)
  gen_nothing_outstanding_test("any_atom nil realized", &Outstand.any_atom/1, nil)
  gen_result_outstanding_test("any_atom value result", &Outstand.any_atom/1, "a", &Outstand.any_atom/1)

  gen_something_outstanding_test("any_bitstring value outstanding", &Outstand.any_bitstring/1, nil)
  gen_nothing_outstanding_test("any_bitstring realized", &Outstand.any_bitstring/1, "aa")
  gen_result_outstanding_test("any_bitstring value result", &Outstand.any_bitstring/1, nil, &Outstand.any_bitstring/1)

  gen_something_outstanding_test("any_boolean value outstanding", &Outstand.any_boolean/1, nil)
  gen_nothing_outstanding_test("any_boolean realized", &Outstand.any_boolean/1, true)
  gen_result_outstanding_test("any_boolean value result", &Outstand.any_boolean/1, nil, &Outstand.any_boolean/1)

  gen_something_outstanding_test("any_date value outstanding", &Outstand.any_date/1, "2025-02-25")
  gen_nothing_outstanding_test("any_date realized", &Outstand.any_date/1, ~D[2025-02-25])
  gen_result_outstanding_test("any_date value result", &Outstand.any_date/1, "2025-02-25", &Outstand.any_date/1)

  gen_something_outstanding_test("any_date_time value outstanding", &Outstand.any_date_time/1, "2025-02-25")
  gen_nothing_outstanding_test("any_date_time realized", &Outstand.any_date_time/1, ~U[2025-02-25 11:59:00.00Z])
  gen_result_outstanding_test("any_date_time value result", &Outstand.any_date_time/1, "2025-02-25", &Outstand.any_date_time/1)

  gen_something_outstanding_test("any_float value outstanding", &Outstand.any_float/1, 1)
  gen_nothing_outstanding_test("any_float realized", &Outstand.any_float/1, 1.1)
  gen_result_outstanding_test("any_float value result", &Outstand.any_float/1, 1, &Outstand.any_float/1)

  gen_something_outstanding_test("any_integer value outstanding", &Outstand.any_integer/1, 1.1)
  gen_nothing_outstanding_test("any_integer realized", &Outstand.any_integer/1, 1)
  gen_result_outstanding_test("any_integer value result", &Outstand.any_integer/1, 1.1, &Outstand.any_integer/1)

  gen_something_outstanding_test("any_list value outstanding", &Outstand.any_list/1, {:a, :b, :c})
  gen_nothing_outstanding_test("any_list realized", &Outstand.any_list/1, [:a])
  gen_nothing_outstanding_test("any_list empty realized", &Outstand.any_list/1, [])
  gen_result_outstanding_test("any_list value result", &Outstand.any_list/1, {:a, :b, :c}, &Outstand.any_list/1)

  gen_something_outstanding_test("any_map value outstanding", &Outstand.any_map/1, [:a])
  gen_nothing_outstanding_test("any_map realized", &Outstand.any_map/1, %{a: :a})
  gen_nothing_outstanding_test("any_map empty realized", &Outstand.any_map/1, %{})
  gen_result_outstanding_test("any_map value result", &Outstand.any_map/1, [:a], &Outstand.any_map/1)

  gen_something_outstanding_test("any_map_set value outstanding", &Outstand.any_map_set/1, [:a])
  gen_nothing_outstanding_test("any_map_set realized", &Outstand.any_map_set/1, MapSet.new([:a]))
  gen_nothing_outstanding_test("any_map_set empty realized", &Outstand.any_map_set/1, MapSet.new())
  gen_result_outstanding_test("any_map_set value result", &Outstand.any_map_set/1, [:a], &Outstand.any_map_set/1)

  gen_something_outstanding_test("any_naive_date_time value outstanding", &Outstand.any_naive_date_time/1, "2025-02-25")
  gen_nothing_outstanding_test("any_naive_date_time realized", &Outstand.any_naive_date_time/1, ~N[2025-02-25 11:59:00])
  gen_result_outstanding_test("any_naive_date_time value result", &Outstand.any_naive_date_time/1, "2025-02-25", &Outstand.any_naive_date_time/1)

  gen_something_outstanding_test("any_number value outstanding", &Outstand.any_number/1, "10")
  gen_nothing_outstanding_test("any_number integer realized", &Outstand.any_number/1, 10)
  gen_nothing_outstanding_test("any_number float realized", &Outstand.any_number/1, 10.1)
  gen_result_outstanding_test("any_number value result", &Outstand.any_number/1, "10", &Outstand.any_number/1)

  gen_something_outstanding_test("any_range value outstanding", &Outstand.any_range/1, 10)
  gen_nothing_outstanding_test("any_range realized", &Outstand.any_range/1, 1..10)
  gen_result_outstanding_test("any_range value result", &Outstand.any_range/1, 10, &Outstand.any_range/1)

  gen_something_outstanding_test("any_time value outstanding", &Outstand.any_time/1, "11:59:00.001")
  gen_nothing_outstanding_test("any_time realized", &Outstand.any_time/1, ~T[11:59:00.001])
  gen_result_outstanding_test("any_time value result", &Outstand.any_time/1, "11:59:00.001", &Outstand.any_time/1)

  gen_something_outstanding_test("any_tuple value outstanding", &Outstand.any_tuple/1, [:a])
  gen_nothing_outstanding_test("any_tuple realized", &Outstand.any_tuple/1, {:a, :b, :c})
  gen_result_outstanding_test("any_tuple value result", &Outstand.any_tuple/1, [:a], &Outstand.any_tuple/1)

  gen_something_outstanding_test("current_date value outstanding", &Outstand.current_date/1, ~D[2002-02-25])
  gen_nothing_outstanding_test("current_date realized", &Outstand.current_date/1, DateTime.utc_now() |> DateTime.to_date())
  gen_result_outstanding_test("current_date value result", &Outstand.current_date/1, "~D[2002-02-25]", &Outstand.current_date/1)

  gen_something_outstanding_test("current_date_time value outstanding", &Outstand.current_date_time/1, ~U[2002-02-25 11:59:00.00Z])
  gen_nothing_outstanding_test("current_date_time realized", &Outstand.current_date_time/1, DateTime.utc_now())
  gen_result_outstanding_test("current_date_time value result", &Outstand.current_date_time/1, "~U[2002-02-25 11:59:00.00Z]", &Outstand.current_date_time/1)

  gen_something_outstanding_test("current_naive_date_time value outstanding", &Outstand.current_naive_date_time/1, ~N[2002-02-25 11:59:00])
  gen_nothing_outstanding_test("current_naive_date_time realized", &Outstand.current_naive_date_time/1, DateTime.utc_now() |> DateTime.to_naive())
  gen_result_outstanding_test("current_naive_date_time value result", &Outstand.current_naive_date_time/1, "~N[2002-02-25 11:59:00]", &Outstand.current_naive_date_time/1)

  gen_something_outstanding_test("current_time value outstanding", &Outstand.current_time/1, ~T[11:59:00.000])
  gen_nothing_outstanding_test("current_time realized", &Outstand.current_time/1, DateTime.utc_now() |> DateTime.to_time())
  gen_result_outstanding_test("current_time value result", &Outstand.current_time/1, "~T[11:59:00.000]", &Outstand.current_time/1)

  gen_something_outstanding_test("empty_list value outstanding", &Outstand.empty_list/1, [:a])
  gen_nothing_outstanding_test("empty_list realized", &Outstand.empty_list/1, [])
  gen_result_outstanding_test("empty_list value result", &Outstand.empty_list/1, [:a], &Outstand.empty_list/1)

  gen_something_outstanding_test("empty_map value outstanding", &Outstand.empty_map/1, %{a: :a})
  gen_nothing_outstanding_test("empty_map realized", &Outstand.empty_map/1, %{})
  gen_result_outstanding_test("empty_map value result", &Outstand.empty_map/1, %{a: :a}, &Outstand.empty_map/1)

  gen_something_outstanding_test("empty_map_set value outstanding", &Outstand.empty_map_set/1, MapSet.new([:a]))
  gen_nothing_outstanding_test("empty_map_set realized", &Outstand.empty_map_set/1, MapSet.new())
  gen_result_outstanding_test("empty_map_set value result", &Outstand.empty_map_set/1, MapSet.new([:a]), &Outstand.empty_map_set/1)

  gen_something_outstanding_test("explicit_nil value outstanding", &Outstand.explicit_nil/1, true)
  gen_nothing_outstanding_test("explicit_nil realized", &Outstand.explicit_nil/1, nil)
  gen_result_outstanding_test("explicit_nil value result", &Outstand.explicit_nil/1, true, &Outstand.explicit_nil/1)

  gen_something_outstanding_test("future_date_time value outstanding", &Outstand.future_date_time/1, ~U[2002-02-25 11:59:00.00Z])
  gen_nothing_outstanding_test("future_date_time realized", &Outstand.future_date_time/1, ~U[2102-02-25 11:59:00.00Z])
  gen_result_outstanding_test("future_date_time value result", &Outstand.future_date_time/1, "~U[2002-02-25 11:59:00.00Z]", &Outstand.future_date_time/1)

  gen_something_outstanding_test("future_naive_date_time value outstanding", &Outstand.future_naive_date_time/1, ~N[2002-02-25 11:59:00])
  gen_nothing_outstanding_test("future_naive_date_time realized", &Outstand.future_naive_date_time/1, ~N[2102-02-25 11:59:00])
  gen_result_outstanding_test("future_naive_date_time value result", &Outstand.future_naive_date_time/1, "~N[2002-02-25 11:59:00]", &Outstand.future_naive_date_time/1)

  gen_something_outstanding_test("future_time value outstanding", &Outstand.future_time/1, ~T[00:00:00.000])
  gen_nothing_outstanding_test("future_time realized", &Outstand.future_time/1, ~T[23:59:59.999])
  gen_result_outstanding_test("future_time value result", &Outstand.future_time/1, "~T[00:00:00.000]", &Outstand.future_time/1)

  gen_something_outstanding_test("non_empty_list value outstanding", &Outstand.non_empty_map/1, [])
  gen_nothing_outstanding_test("non_empty_list realized", &Outstand.non_empty_list/1, [:a])
  gen_result_outstanding_test("non_empty_list value result", &Outstand.non_empty_list/1, [], &Outstand.non_empty_list/1)

  gen_something_outstanding_test("non_empty_map value outstanding", &Outstand.non_empty_map/1, %{})
  gen_nothing_outstanding_test("non_empty_map realized", &Outstand.non_empty_map/1, %{a: :a})
  gen_result_outstanding_test("non_empty_map value result", &Outstand.non_empty_map/1, %{}, &Outstand.non_empty_map/1)

  gen_something_outstanding_test("non_empty_map_set value outstanding", &Outstand.non_empty_map_set/1, MapSet.new())
  gen_nothing_outstanding_test("non_empty_map_set realized", &Outstand.non_empty_map_set/1, MapSet.new([:a]))
  gen_result_outstanding_test("non_empty_map_set value result", &Outstand.non_empty_map_set/1, MapSet.new(), &Outstand.non_empty_map_set/1)

  gen_something_outstanding_test("past_date_time value outstanding", &Outstand.past_date_time/1, ~U[2102-02-25 11:59:00.00Z])
  gen_nothing_outstanding_test("past_date_time realized", &Outstand.past_date_time/1, ~U[2002-02-25 11:59:00.00Z])
  gen_result_outstanding_test("past_date_time value result", &Outstand.past_date_time/1, "~U[2102-02-25 11:59:00.00Z]", &Outstand.past_date_time/1)

  gen_something_outstanding_test("past_naive_date_time value outstanding", &Outstand.past_naive_date_time/1, ~N[2102-02-25 11:59:00])
  gen_nothing_outstanding_test("past_naive_date_time realized", &Outstand.past_naive_date_time/1, ~N[2002-02-25 11:59:00])
  gen_result_outstanding_test("past_naive_date_time value result", &Outstand.past_naive_date_time/1, "~N[2102-02-25 11:59:00]", &Outstand.past_naive_date_time/1)

  gen_something_outstanding_test("past_time value outstanding", &Outstand.past_time/1, ~T[23:59:59.999])
  gen_nothing_outstanding_test("past_time realized", &Outstand.past_time/1, ~T[00:00:00.000])
  gen_result_outstanding_test("past_time value result", &Outstand.past_time/1, "~T[23:59:59.999]", &Outstand.past_time/1)

  gen_something_outstanding_test("odd value outstanding", &Integer.is_odd/1, 2)
  gen_nothing_outstanding_test("odd value realized", &Integer.is_odd/1, 3)

  # TODO fix this, the problem is likely due to the macro, since it quotes and returns a different function
  #1) test odd value result (Outstanding.FunctionTest)
  #test/function_test.exs:141
  #Assertion with == failed
  #code:  assert uq_expected --- uq_actual == uq_outstanding
  #left:  #Function<2.32136784/1 in Outstanding.FunctionTest."test odd value result"/1>
  #right: #Function<3.32136784/1 in Outstanding.FunctionTest."test odd value result"/1>
  #stacktrace:
    #test/function_test.exs:141: (test)
  gen_result_outstanding_test("odd value result", &Integer.is_odd/1, 2, &Integer.is_odd/1)


end
