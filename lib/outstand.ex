defmodule Outstand do
  @moduledoc """
  Provides utilities to implement and work with `Outstanding` types
  """

  @doc """
  Enables infix `---`, `>>>` shortcuts, `defoutstanding`,
  `gen_nothing_outstanding_test`, `gen_something_outstanding_test` `gen_result_outstanding_test` macro
  """
  defmacro __using__(_) do
    quote do
      require Outstand

      import Outstand,
        only: [
          ---: 2,
          >>>: 2,
          defoutstanding: 3,
          gen_nothing_outstanding_test: 3,
          gen_something_outstanding_test: 3,
          gen_result_outstanding_test: 4,
          outstanding?: 2,
          outstanding?: 1,
          any_atom: 1,
          any_bitstring: 1,
          any_boolean: 1,
          any_date: 1,
          any_date_time: 1,
          any_float: 1,
          any_integer: 1,
          any_map: 1,
          any_map_set: 1,
          any_naive_date_time: 1,
          any_number: 1,
          any_range: 1,
          any_time: 1,
          any_tuple: 1,
          current_date: 1,
          current_date_time: 1,
          current_naive_date_time: 1,
          current_time: 1,
          empty_list: 1,
          empty_map: 1,
          empty_map_set: 1,
          explicit_nil: 1,
          future_date: 1,
          future_date_time: 1,
          future_naive_date_time: 1,
          future_time: 1,
          non_empty_list: 1,
          non_empty_map: 1,
          non_empty_map_set: 1,
          non_nil_atom: 1,
          past_date: 1,
          past_date_time: 1,
          past_naive_date_time: 1,
          past_time: 1,
          suppress: 1,
        ]
    end
  end

  @doc """
  Helper to define whether the expected side (expected) is realised by actual side (actual), returns nil if so,
  otherwise return what is not realised (outstanding)
  accepts two `term :: type` pairs
  and block of code where relation is described.

  ## Examples

  ```
  iex> quote do
  ...>   use Outstand
  ...>   defmodule Foo do
  ...>     defstruct [:value, :meta]
  ...>   end
  ...>   defmodule Bar do
  ...>     defstruct [:value, :meta]
  ...>   end
  ...>   defoutstanding expected :: Foo, actual :: Any do
  ...>     case Outstand.type_of(actual) do
  ...>       Foo -> Outstanding.outstanding(expected.value, actual.value)
  ...>       Bar -> Outstanding.outstanding(expected.value, actual.value)
  ...>       Integer -> Outstanding.outstanding(expected.value, actual)
  ...>       _ -> expected
  ...>     end
  ...>   end
  ...> end
  ...> |> Code.compile_quoted
  iex> quote do
  ...>   expected = %Foo{value: 1, meta: 1}
  ...>   actual = %Foo{value: 1, meta: 2}
  ...>   Outstanding.outstanding(expected, actual)
  ...> end
  ...> |> Code.eval_quoted
  ...> |> elem(0)
  nil
  iex> quote do
  ...>   expected = %Foo{value: 1, meta: 1}
  ...>   actual = %Bar{value: 1, meta: 2}
  ...>   Outstanding.outstanding(expected, actual)
  ...> end
  ...> |> Code.eval_quoted
  ...> |> elem(0)
  nil
  iex> quote do
  ...>   expected = %Foo{value: 1, meta: 1}
  ...>   actual = 1
  ...>   Outstanding.outstanding(expected, actual)
  ...> end
  ...> |> Code.eval_quoted
  ...> |> elem(0)
  nil
  ```
  """
  defmacro defoutstanding(
             {:"::", _, [expected_expression, quoted_expected_type]},
             {:"::", _, [actual_expression, _quoted_actual_type]},
             do: code
           ) do
    {expected_type, []} = Code.eval_quoted(quoted_expected_type, [], __CALLER__)

    quote do
      defimpl Outstanding, for: unquote(expected_type) do
        def outstanding(unquote(expected_expression), unquote(actual_expression)) do
          unquote(code)
        end
      end
    end
  end

  defmacro gen_nothing_outstanding_test(name, expected, actual) do
    quote do
      test unquote(name) do
        uq_expected = unquote(expected)
        uq_actual = unquote(actual)
        assert uq_expected --- uq_actual == nil
        assert Outstanding.outstanding(uq_expected, uq_actual) == nil
        refute uq_expected >>> uq_actual
        refute Outstand.outstanding?(uq_expected, uq_actual)
      end
    end
  end

  defmacro gen_something_outstanding_test(name, expected, actual) do
    quote do
      test unquote(name) do
        uq_expected = unquote(expected)
        uq_actual = unquote(actual)
        assert uq_expected --- uq_actual != nil
        assert Outstanding.outstanding(uq_expected, uq_actual) != nil
        assert uq_expected >>> uq_actual
        assert Outstand.outstanding?(uq_expected, uq_actual)
      end
    end
  end

  defmacro gen_result_outstanding_test(name, expected, actual, outstanding) do
    if (is_function(expected)) do
      IO.inspect(expected, label: "gen result outstanding test - function")
      quote do
        test unquote(name) do
          uq_expected = unquote(expected)
          uq_actual = unquote(actual)
          assert expected --- uq_actual == outstanding
          assert Outstanding.outstanding(expected, uq_actual) == outstanding
          assert expected >>> uq_actual == Outstand.outstanding?(uq_outstanding)
          assert Outstand.outstanding?(expected, uq_actual) == Outstand.outstanding?(outstanding)
        end
      end
    else
      quote do
        test unquote(name) do
          uq_expected = unquote(expected)
          uq_actual = unquote(actual)
          uq_outstanding = unquote(outstanding)
          assert uq_expected --- uq_actual == uq_outstanding
          assert Outstanding.outstanding(uq_expected, uq_actual) == uq_outstanding
          assert uq_expected >>> uq_actual == Outstand.outstanding?(uq_outstanding)
          assert Outstand.outstanding?(uq_expected, uq_actual) == Outstand.outstanding?(uq_outstanding)
        end
      end
    end
  end

  @doc """
  Infix shortcut --- for `Outstanding.outstanding/2`

  ## Examples

  ```
  iex> use Outstand
  Outstand
  iex> 1 --- 1
  nil
  iex> 1 --- :hello
  1
  ```
  """
  defmacro expected --- actual do
    quote do
      unquote(expected)
      |> Outstanding.outstanding(unquote(actual))
    end
  end

  @doc """
  Infix shortcut >>> for `Outstand.outstanding?/2`

  ## Examples

  ```
  iex> use Outstand
  Outstand
  iex> 1 >>> 1
  false
  iex> 1 >>> :hello
  true
  ```
  """
  defmacro expected >>> actual do
    quote do
      unquote(expected)
      |> Outstand.outstanding?(unquote(actual))
    end
  end

  @doc """
  Checks whether a result has anything outstanding

  ## Examples

  ```
  iex> Outstand.outstanding?(1)
  true
  iex> Outstand.outstanding?(nil)
  false
  iex> Outstand.outstanding?(%{})
  true
  iex> Outstand.outstanding?([])
  true
  ```
  """
  def outstanding?(outstanding) do
    case outstanding do
      nil -> false
      _ -> true
    end
  end

  @doc """
  Is anything oustanding given expected and actual term?

  ## Examples
  ```
  iex> Outstand.outstanding?(1, 1)
  false
  iex> Outstand.outstanding?(1, nil)
  true
  iex> Outstand.outstanding?(1, 2)
  true
  ```
  """
  @spec outstanding?(Outstanding.t, any) :: boolean()
  def outstanding?(expected, actual) do
    outstanding?(Outstanding.outstanding(expected, actual))
  end


  @doc """
  Suppress outstanding result when empty map or list

  ## Examples

  ```
  iex> Outstand.suppress(%{})
  nil
  iex> Outstand.suppress(%{x: :a})
  %{x: :a}
  iex> Outstand.suppress(MapSet.new())
  nil
  iex> Outstand.suppress(MapSet.new([:a]))
  MapSet.new([:a])
  iex> Outstand.suppress([])
  nil
  iex> Outstand.suppress([:a])
  [:a]
  ```
  """
  def suppress(enum) when is_map(enum) or is_list(enum) do
    if (Enum.empty?(enum)) do
      nil
    else
      enum
    end
  end


  def suppress(term) when is_nil(term) do
    nil
  end

  @doc """
  Function which expects any atom (nil is an atom)

  ## Examples
  ```
  iex> Outstand.any_atom(:a)
  true
  iex> Outstand.any_atom(nil)
  true
  iex> Outstand.any_atom("a")
  false
  ```
  """
  @spec any_atom(any()) :: boolean
  def any_atom(actual) do
    is_atom(actual)
  end

  @doc """
  Function which expects any bitstring

  ## Examples
  ```
  iex> Outstand.any_bitstring("a")
  true
  iex> Outstand.any_bitstring(:a)
  false
  iex> Outstand.any_bitstring(nil)
  false
  ```
  """
  @spec any_bitstring(any()) :: boolean
  def any_bitstring(actual) do
    is_bitstring(actual)
  end

  @doc """
  Function which expects any boolean

  ## Examples
  ```
  iex> Outstand.any_boolean(true)
  true
  iex> Outstand.any_boolean("a")
  false
  iex> Outstand.any_boolean(nil)
  false
  ```
  """
  @spec any_boolean(any()) :: boolean
  def any_boolean(actual) do
    is_boolean(actual)
  end

  @doc """
  Function which expects any date

  ## Examples
  ```
  iex> Outstand.any_date(~D[2025-02-25])
  true
  iex> Outstand.any_date("2025-02-25")
  false
  iex> Outstand.any_date(nil)
  false
  ```
  """
  @spec any_date(any()) :: boolean()
  def any_date(actual) do
    case actual do
      %Date{} ->
        true
      _ ->
        false
    end
  end

  @doc """
  Function which expects any date time

  ## Examples
  ```
  iex> Outstand.any_date_time(~U[2025-02-25 11:59:00.00Z])
  true
  iex> Outstand.any_date_time("2025-02-25")
  false
  iex> Outstand.any_date_time(nil)
  false
  ```
  """
  @spec any_date_time(any()) :: boolean
  def any_date_time(actual) do
    case actual do
      %DateTime{} ->
        true
      _ ->
        false
    end
  end

  @doc """
  Function which expects any naive date time

  ## Examples
  ```
  iex> Outstand.any_naive_date_time(~N[2025-02-25 11:59:00])
  true
  iex> Outstand.any_naive_date_time("2025-02-25")
  false
  iex> Outstand.any_naive_date_time(nil)
  false
  ```
  """
  @spec any_naive_date_time(any()) :: boolean
  def any_naive_date_time(actual) do
    case actual do
      %NaiveDateTime{} ->
        true
      _ ->
        false
    end
  end

  @doc """
  Function which expects any naive date time

  ## Examples
  ```
  iex> Outstand.any_time(~T[11:59:00.000])
  true
  iex> Outstand.any_time("11:59:00.000")
  false
  iex> Outstand.any_time(nil)
  false
  ```
  """
  @spec any_time(any()) :: boolean
  def any_time(actual) do
    case actual do
      %Time{} ->
        true
      _ ->
        false
    end
  end

  @doc """
  Function which expects any float

  ## Examples
  ```
  iex> Outstand.any_float(1.1)
  true
  iex> Outstand.any_float(1)
  false
  iex> Outstand.any_float(nil)
  false
  ```
  """
  @spec any_float(any()) :: boolean
  def any_float(actual) do
    is_float(actual)
  end

  @doc """
  Function which expects any integer

  ## Examples
  ```
  iex> Outstand.any_integer(1)
  true
  iex> Outstand.any_integer(1.1)
  false
  iex> Outstand.any_integer(nil)
  false
  ```
  """
  @spec any_integer(any()) :: boolean
  def any_integer(actual) do
    is_integer(actual)
  end

  @doc """
  Function which expects any list, including []

  ## Examples
  ```
  iex> Outstand.any_list([:a])
  true
  iex> Outstand.any_list([])
  true
  iex> Outstand.any_list({:a, :b, :c})
  false
  iex> Outstand.any_list(nil)
  false
  ```
  """
  @spec any_list(any()) :: boolean
  def any_list(actual) do
    is_list(actual)
  end

  @doc """
  Function which expects any map

  ## Examples
  ```
  iex> Outstand.any_map(%{a: :a})
  true
  iex> Outstand.any_map([:a])
  false
  iex> Outstand.any_map(nil)
  false
  ```
  """
  @spec any_map(any()) :: boolean
  def any_map(actual) do
    is_map(actual)
  end

  @doc """
  Function which expects any map set

  ## Examples
  ```
  iex> Outstand.any_map_set(MapSet.new())
  true
  iex> Outstand.any_map_set(MapSet.new([:a]))
  true
  iex> Outstand.any_map_set([:a])
  false
  iex> Outstand.any_map_set(nil)
  false
  ```
  """
  @spec any_map_set(any()) :: boolean
  def any_map_set(actual) do
    case actual do
      %MapSet{} ->
        true
      _ ->
        false
    end
  end

  @doc """
  Function which expects any number

  ## Examples
  ```
  iex> Outstand.any_number(1)
  true
  iex> Outstand.any_number(1.1)
  true
  iex> Outstand.any_number("1")
  false
  iex> Outstand.any_number(nil)
  false
  ```
  """
  @spec any_number(any()) :: boolean
  def any_number(actual) do
    is_integer(actual) or is_float(actual)
  end

  @doc """
  Function which expects any range

  ## Examples
  ```
  iex> Outstand.any_range(0..25//5)
  true
  iex> Outstand.any_range(5)
  false
  iex> Outstand.any_range(nil)
  false
  ```
  """
  @spec any_range(any()) :: boolean
  def any_range(actual) do
    case actual do
      _first.._last//_step ->
        true
      _ ->
        false
    end
  end

  @doc """
  Function which expects any tuple

  ## Examples
  ```
  iex> Outstand.any_tuple({:a, :b, :c})
  true
  iex> Outstand.any_tuple([:a])
  false
  iex> Outstand.any_tuple(nil)
  false
  ```
  """
  @spec any_tuple(any()) :: boolean
  def any_tuple(actual) do
    is_tuple(actual)
  end

  @doc """
  Function which expects current date

  ## Examples
  ```
  iex> today = DateTime.utc_now() |> DateTime.to_date()
  iex> Outstand.current_date(today)
  true
  iex> Outstand.current_date(today |> Date.add(1))
  false
  iex> Outstand.current_date(today |> Date.add(-1))
  false
  iex> Outstand.current_date(nil)
  false
  ```
  """
  @spec current_date(any()) :: boolean
  def current_date(actual) do
    case actual do
      %Date{} ->
         case Date.compare(actual, DateTime.utc_now() |> DateTime.to_date()) do
           :eq ->
            true
           _ ->
            false
         end
      _ ->
        false
    end
  end

  @doc """
  Function which expects current date time (+/- 1 min from now)

  ## Examples
  ```
  iex> now = DateTime.utc_now()
  iex> Outstand.current_date_time(now)
  true
  iex> Outstand.current_date_time(now |> DateTime.add(2, :minute))
  false
  iex> Outstand.current_date_time(now |> DateTime.add(-2, :minute))
  false
  iex> Outstand.current_date_time(nil)
  false
  ```
  """
  @spec current_date_time(any()) :: boolean
  def current_date_time(actual) do
    case actual do
      %DateTime{} ->
        DateTime.after?(actual, DateTime.utc_now() |> DateTime.add(-1, :minute)) &&
          DateTime.before?(actual, DateTime.utc_now() |> DateTime.add(1, :minute))
      _ ->
        false
    end
  end

  @doc """
  Function which expects current naive date time (+/- 1 min from now)

  ## Examples
  ```
  iex> now = DateTime.utc_now() |> DateTime.to_naive()
  iex> Outstand.current_naive_date_time(now)
  true
  iex> Outstand.current_naive_date_time(now |> NaiveDateTime.add(2, :minute))
  false
  iex> Outstand.current_naive_date_time(now |> NaiveDateTime.add(-2, :minute))
  false
  iex> Outstand.current_naive_date_time(nil)
  false
  ```
  """
  @spec current_naive_date_time(any()) :: boolean
  def current_naive_date_time(actual) do
    case actual do
      %NaiveDateTime{} ->
        NaiveDateTime.after?(actual, DateTime.utc_now() |> DateTime.to_naive() |> NaiveDateTime.add(-1, :minute)) &&
          NaiveDateTime.before?(actual, DateTime.utc_now() |> DateTime.to_naive() |> NaiveDateTime.add(1, :minute))
      _ ->
        false
    end
  end

  @doc """
  Function which expects current time (+/- 1 min from now)

  ## Examples
  ```
  iex> now = DateTime.utc_now() |> DateTime.to_time()
  iex> Outstand.current_time(now)
  true
  iex> Outstand.current_time(now |> Time.add(2, :minute))
  false
  iex> Outstand.current_time(now |> Time.add(-2, :minute))
  false
  iex> Outstand.current_time(nil)
  false
  ```
  """
  @spec current_time(any()) :: boolean
  def current_time(actual) do
    case actual do
      %Time{} ->
        Time.after?(actual, DateTime.utc_now() |> DateTime.to_time() |> Time.add(-1, :minute)) &&
          Time.before?(actual, DateTime.utc_now() |> DateTime.to_time() |> Time.add(1, :minute))
      _ ->
        false
    end
  end

  @doc """
  Function which expects empty list

  ## Examples
  ```
  iex> Outstand.empty_list([])
  true
  iex> Outstand.empty_list([:a])
  false
  iex> Outstand.empty_list(nil)
  false
  ```
  """
  @spec empty_list(any()) :: boolean
  def empty_list(actual) do
    is_list(actual) && Enum.empty?(actual)
  end

  @doc """
  Function which expects empty map

  ## Examples
  ```
  iex> Outstand.empty_map(%{})
  true
  iex> Outstand.empty_map(%{a: :a})
  false
  iex> Outstand.empty_map(nil)
  false
  ```
  """
  @spec empty_map(any()) :: boolean
  def empty_map(actual) do
    is_map(actual) && Enum.empty?(actual)
  end

  @doc """
  Function which expects empty map set

  ## Examples
  ```
  iex> Outstand.empty_map_set(MapSet.new())
  true
  iex> Outstand.empty_map_set(MapSet.new([:a]))
  false
  iex> Outstand.empty_map_set(nil)
  false
  ```
  """
  @spec empty_map_set(any()) :: boolean
  def empty_map_set(actual) do
    case actual do
      %MapSet{} ->
        Enum.empty?(actual)
      _ ->
        false
    end
  end

  @doc """
  Function which expects explicit nil

  ## Examples
  ```
  iex> Outstand.explicit_nil(nil)
  true
  iex> Outstand.explicit_nil(:a)
  false
  ```
  """
  @spec explicit_nil(any()) :: boolean
  def explicit_nil(actual) do
    actual == nil
  end

  @doc """
  Function which expects future date

  ## Examples
  ```
  iex> Outstand.future_date(~D[2102-02-25])
  true
  iex> Outstand.future_date(~D[2002-02-25])
  false
  iex> Outstand.future_date(nil)
  false
  ```
  """
  @spec future_date(any()) :: boolean
  def future_date(actual) do
    case actual do
      %Date{} ->
        Date.after?(actual, DateTime.utc_now() |> DateTime.to_date())
      _ ->
        false
    end
  end

  @doc """
  Function which expects future date time

  ## Examples
  ```
  iex> Outstand.future_date_time(~U[2102-02-25 11:59:00.00Z])
  true
  iex> Outstand.future_date_time(~U[2002-02-25 11:59:00.00Z])
  false
  iex> Outstand.future_date_time(nil)
  false
  ```
  """
  @spec future_date_time(any()) :: boolean
  def future_date_time(actual) do
    case actual do
      %DateTime{} ->
        DateTime.after?(actual, DateTime.utc_now())
      _ ->
        false
    end
  end

  @doc """
  Function which expects future naive date time

  ## Examples
  ```
  iex> Outstand.future_naive_date_time(~N[2102-02-25 11:59:00])
  true
  iex> Outstand.future_naive_date_time(~N[2002-02-25 11:59:00])
  false
  iex> Outstand.future_naive_date_time(nil)
  false
  ```
  """
  @spec future_naive_date_time(any()) :: boolean
  def future_naive_date_time(actual) do
    case actual do
      %NaiveDateTime{} ->
        NaiveDateTime.after?(actual, DateTime.utc_now() |> DateTime.to_naive())
      _ ->
        false
    end
  end

  @doc """
  Function which expects future time

  ## Examples
  ```
  iex> Outstand.future_time(~T[23:59:59])
  true
  iex> Outstand.future_time(~T[00:00:00])
  false
  iex> Outstand.future_time(nil)
  false
  ```
  """
  @spec future_time(any()) :: boolean
  def future_time(actual) do
    case actual do
      %Time{} ->
        Time.after?(actual, DateTime.utc_now() |> DateTime.to_time())
      _ ->
        false
    end
  end

  @doc """
  Function which expects non empty list

  ## Examples
  ```
  iex> Outstand.non_empty_list([:a])
  true
  iex> Outstand.non_empty_list([])
  false
  iex> Outstand.non_empty_list(nil)
  false
  ```
  """
  @spec non_empty_list(any()) :: boolean
  def non_empty_list(actual) do
    is_list(actual) && !Enum.empty?(actual)
  end

  @doc """
  Function which expects non empty map

  ## Examples
  ```
  iex> Outstand.non_empty_map(%{a: :a})
  true
  iex> Outstand.non_empty_map(%{})
  false
  iex> Outstand.non_empty_map(nil)
  false
  ```
  """
  @spec non_empty_map(any()) :: boolean
  def non_empty_map(actual) do
    is_map(actual) && !Enum.empty?(actual)
  end

  @doc """
  Function which expects non empty map set

  ## Examples
  ```
  iex> Outstand.non_empty_map_set(MapSet.new([:a]))
  true
  iex> Outstand.non_empty_map_set(MapSet.new())
  false
  iex> Outstand.non_empty_map_set(nil)
  false
  ```
  """
  @spec non_empty_map_set(any()) :: boolean
  def non_empty_map_set(actual) do
    case actual do
      %MapSet{} ->
        !Enum.empty?(actual)
      _ ->
        false
    end
  end

  @doc """
  Function which expects any not nil atom

  ## Examples
  ```
  iex> Outstand.non_nil_atom(:a)
  true
  iex> Outstand.non_nil_atom(nil)
  false
  iex> Outstand.non_nil_atom("a")
  false
  ```
  """
  @spec non_nil_atom(any()) :: boolean
  def non_nil_atom(actual) do
    actual != nil && is_atom(actual)
  end

  @doc """
  Function which expects past date

  ## Examples
  ```
  iex> Outstand.past_date(~D[2002-02-25])
  true
  iex> Outstand.past_date(~D[2102-02-25])
  false
  iex> Outstand.past_date(nil)
  false
  ```
  """
  @spec past_date(any()) :: boolean
  def past_date(actual) do
    case actual do
      %Date{} ->
        Date.before?(actual, DateTime.utc_now() |> DateTime.to_date())
      _ ->
        false
    end
  end

  @doc """
  Function which expects past date time

  ## Examples
  ```
  iex> Outstand.past_date_time(~U[2002-02-25 11:59:00.00Z])
  true
  iex> Outstand.past_date_time(~U[2102-02-25 11:59:00.00Z])
  false
  iex> Outstand.past_date_time(nil)
  false
  ```
  """
  @spec past_date_time(any()) :: boolean
  def past_date_time(actual) do
    case actual do
      %DateTime{} ->
        DateTime.before?(actual, DateTime.utc_now())
      _ ->
        false
    end
  end

  @doc """
  Function which expects past date time

  ## Examples
  ```
  iex> Outstand.past_naive_date_time(~N[2002-02-25 11:59:00])
  true
  iex> Outstand.past_naive_date_time(~N[2102-02-25 11:59:00])
  false
  iex> Outstand.past_naive_date_time(nil)
  false
  ```
  """
  @spec past_naive_date_time(any()) :: boolean
  def past_naive_date_time(actual) do
    case actual do
      %NaiveDateTime{} ->
        NaiveDateTime.before?(actual, DateTime.utc_now() |> DateTime.to_naive())
      _ ->
        false
    end
  end

  @doc """
  Function which expects past time

  ## Examples
  ```
  iex> Outstand.past_time(~T[00:00:00.000])
  true
  iex> Outstand.past_time(~T[23:59:59.999])
  false
  iex> Outstand.past_time(nil)
  false
  ```
  """
  @spec past_time(any()) :: boolean
  def past_time(actual) do
    case actual do
      %Time{} ->
        Time.before?(actual, DateTime.utc_now() |> DateTime.to_time())
      _ ->
        false
    end
  end

  @doc """
  Types the argument, similar to Typable

  ## Examples
  ```
  iex> Outstand.type_of(nil)
  Atom
  iex> Outstand.type_of(:a)
  Atom
  iex> Outstand.type_of(true)
  Boolean
  iex> Outstand.type_of("a")
  BitString
  iex> Outstand.type_of(1.1)
  Float
  iex> Outstand.type_of(&Outstand.any_atom/1)
  Function
  iex> Outstand.type_of(1)
  Integer
  iex> Outstand.type_of([:a])
  List
  iex> Outstand.type_of(%{a: :a})
  Map
  iex> Outstand.type_of(MapSet.new([:a]))
  MapSet
  iex> Outstand.type_of(0..25//5)
  Range
  iex> Outstand.type_of({:a, :b, :c})
  Tuple
  iex> Outstand.type_of(~U[2025-02-25 11:59:00.00Z])
  DateTime
  iex> Outstand.type_of(~D[2025-02-25])
  Date
  ```
  """
  @spec type_of(any()) :: module()
  def type_of(term) do
    case term do
      _first.._last//_step  -> Range
      %MapSet{}             -> MapSet
      %_{}                  -> term.__struct__

      _ ->
        cond do
          is_boolean(term)   -> Boolean
          is_atom(term)      -> Atom
          is_bitstring(term) -> BitString
          is_float(term)     -> Float
          is_function(term)  -> Function
          is_integer(term)   -> Integer
          is_list(term)      -> List
          is_map(term)       -> Map
          is_tuple(term)     -> Tuple
          true               -> Any
        end
    end
  end
end
