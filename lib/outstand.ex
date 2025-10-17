# SPDX-FileCopyrightText: 2025 outstanding contributors <https://github.com/diffo-dev/outstanding/graphs.contributors>
#
# SPDX-License-Identifier: MIT

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
          nil_outstanding?: 2,
          outstanding?: 1,
          nil_outstanding?: 1,
          any_atom: 1,
          any_bitstring: 1,
          any_boolean: 1,
          any_date: 1,
          any_date_time: 1,
          any_duration: 1,
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
          all_of: 2,
          any_of: 2,
          none_of: 2,
          one_of: 2
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

        def outstanding?(unquote(expected_expression), unquote(actual_expression)) do
          outstanding?(outstanding(unquote(expected_expression), unquote(actual_expression)))
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
        refute Outstanding.outstanding?(uq_expected, uq_actual)
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
        assert Outstanding.outstanding?(uq_expected, uq_actual)
      end
    end
  end

  defmacro gen_result_outstanding_test(name, expected, actual, outstanding) do
    quote do
      test unquote(name) do
        uq_expected = unquote(expected)
        uq_actual = unquote(actual)
        uq_outstanding = unquote(outstanding)
        assert uq_expected --- uq_actual == uq_outstanding
        assert Outstanding.outstanding(uq_expected, uq_actual) == uq_outstanding
        assert uq_expected >>> uq_actual == Outstand.outstanding?(uq_outstanding)
        assert Outstanding.outstanding?(uq_expected, uq_actual) == Outstand.outstanding?(uq_outstanding)
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
  Infix shortcut >>> for `Outstanding.outstanding?/2`

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
      |> Outstanding.outstanding?(unquote(actual))
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
  Checks whether a result has nothing outstanding

  ## Examples

  ```
  iex> Outstand.nil_outstanding?(1)
  false
  iex> Outstand.nil_outstanding?(nil)
  true
  iex> Outstand.nil_outstanding?(%{})
  false
  iex> Outstand.nil_outstanding?([])
  false
  ```
  """
  def nil_outstanding?(outstanding) do
    not outstanding?(outstanding)
  end

  @doc """
  Is nothing outstanding given expected and actual term?

  ## Examples
  ```
  iex> Outstand.nil_outstanding?(1, 1)
  true
  iex> Outstand.nil_outstanding?(1, nil)
  false
  iex> Outstand.nil_outstanding?(1, 2)
  false
  ```
  """
  @spec nil_outstanding?(Outstanding.t(), any) :: boolean()
  def nil_outstanding?(expected, actual) do
    not Outstanding.outstanding?(expected, actual)
  end

  @doc """
  Function which expects any atom (nil is an atom)

  ## Examples
  ```
  iex> Outstand.any_atom(:a)
  nil
  iex> Outstand.any_atom(nil)
  nil
  iex> Outstand.any_atom("a")
  :any_atom
  ```
  """
  @spec any_atom(any()) :: :any_atom | nil
  def any_atom(actual) do
    if is_atom(actual) do
      nil
    else
      :any_atom
    end
  end

  @doc """
  Function which expects any bitstring

  ## Examples
  ```
  iex> Outstand.any_bitstring("a")
  nil
  iex> Outstand.any_bitstring(:a)
  :any_bitstring
  iex> Outstand.any_bitstring(nil)
  :any_bitstring
  ```
  """
  @spec any_bitstring(any()) :: :any_bitstring | nil
  def any_bitstring(actual) do
    if is_bitstring(actual) do
      nil
    else
      :any_bitstring
    end
  end

  @doc """
  Function which expects any boolean

  ## Examples
  ```
  iex> Outstand.any_boolean(true)
  nil
  iex> Outstand.any_boolean("a")
  :any_boolean
  iex> Outstand.any_boolean(nil)
  :any_boolean
  ```
  """
  @spec any_boolean(any()) :: :any_boolean | nil
  def any_boolean(actual) do
    if is_boolean(actual) do
      nil
    else
      :any_boolean
    end
  end

  @doc """
  Function which expects any date

  ## Examples
  ```
  iex> Outstand.any_date(~D[2025-02-25])
  nil
  iex> Outstand.any_date("2025-02-25")
  :any_date
  iex> Outstand.any_date(nil)
  :any_date
  ```
  """
  @spec any_date(any()) :: :any_date | nil
  def any_date(actual) do
    case actual do
      %Date{} ->
        nil

      _ ->
        :any_date
    end
  end

  @doc """
  Function which expects any date time

  ## Examples
  ```
  iex> Outstand.any_date_time(~U[2025-02-25 11:59:00.00Z])
  nil
  iex> Outstand.any_date_time("2025-02-25")
  :any_date_time
  iex> Outstand.any_date_time(nil)
  :any_date_time
  ```
  """
  @spec any_date_time(any()) :: :any_date_time | nil
  def any_date_time(actual) do
    case actual do
      %DateTime{} ->
        nil

      _ ->
        :any_date_time
    end
  end

  @doc """
  Function which expects any duration

  ## Examples
  ```
  iex> Outstand.any_duration(%Duration{month: 1})
  nil
  iex> Outstand.any_duration(%{month: 1})
  :any_duration
  iex> Outstand.any_duration(nil)
  :any_duration
  ```
  """
  @spec any_duration(any()) :: :any_duration | nil
  def any_duration(actual) do
    case actual do
      %Duration{} ->
        nil

      _ ->
        :any_duration
    end
  end

  @doc """
  Function which expects any naive date time

  ## Examples
  ```
  iex> Outstand.any_naive_date_time(~N[2025-02-25 11:59:00])
  nil
  iex> Outstand.any_naive_date_time("2025-02-25")
  :any_naive_date_time
  iex> Outstand.any_naive_date_time(nil)
  :any_naive_date_time
  ```
  """
  @spec any_naive_date_time(any()) :: :any_naive_date_time | nil
  def any_naive_date_time(actual) do
    case actual do
      %NaiveDateTime{} ->
        nil

      _ ->
        :any_naive_date_time
    end
  end

  @doc """
  Function which expects any naive date time

  ## Examples
  ```
  iex> Outstand.any_time(~T[11:59:00.000])
  nil
  iex> Outstand.any_time("11:59:00.000")
  :any_time
  iex> Outstand.any_time(nil)
  :any_time
  ```
  """
  @spec any_time(any()) :: :any_time | nil
  def any_time(actual) do
    case actual do
      %Time{} ->
        nil

      _ ->
        :any_time
    end
  end

  @doc """
  Function which expects any float

  ## Examples
  ```
  iex> Outstand.any_float(1.1)
  nil
  iex> Outstand.any_float(1)
  :any_float
  iex> Outstand.any_float(nil)
  :any_float
  ```
  """
  @spec any_float(any()) :: :any_float | nil
  def any_float(actual) do
    if is_float(actual) do
      nil
    else
      :any_float
    end
  end

  @doc """
  Function which expects any integer

  ## Examples
  ```
  iex> Outstand.any_integer(1)
  nil
  iex> Outstand.any_integer(1.1)
  :any_integer
  iex> Outstand.any_integer(nil)
  :any_integer
  ```
  """
  @spec any_integer(any()) :: :any_integer | nil
  def any_integer(actual) do
    if is_integer(actual) do
      nil
    else
      :any_integer
    end
  end

  @doc """
  Function which expects any list, including []

  ## Examples
  ```
  iex> Outstand.any_list([:a])
  nil
  iex> Outstand.any_list([])
  nil
  iex> Outstand.any_list({:a, :b, :c})
  :any_list
  iex> Outstand.any_list(nil)
  :any_list
  ```
  """
  @spec any_list(any()) :: :any_list | nil
  def any_list(actual) do
    if is_list(actual) do
      nil
    else
      :any_list
    end
  end

  @doc """
  Function which expects any map

  ## Examples
  ```
  iex> Outstand.any_map(%{a: :a})
  nil
  iex> Outstand.any_map([:a])
  :any_map
  iex> Outstand.any_map(nil)
  :any_map
  ```
  """
  @spec any_map(any()) :: :any_map | nil
  def any_map(actual) do
    if is_map(actual) do
      nil
    else
      :any_map
    end
  end

  @doc """
  Function which expects any map set

  ## Examples
  ```
  iex> Outstand.any_map_set(MapSet.new())
  nil
  iex> Outstand.any_map_set(MapSet.new([:a]))
  nil
  iex> Outstand.any_map_set([:a])
  :any_map_set
  iex> Outstand.any_map_set(nil)
  :any_map_set
  ```
  """
  @spec any_map_set(any()) :: :any_map_set | nil
  def any_map_set(actual) do
    case actual do
      %MapSet{} ->
        nil

      _ ->
        :any_map_set
    end
  end

  @doc """
  Function which expects any number

  ## Examples
  ```
  iex> Outstand.any_number(1)
  nil
  iex> Outstand.any_number(1.1)
  nil
  iex> Outstand.any_number(nil)
  :any_number
  ```
  """
  @spec any_number(any()) :: :any_number | nil
  def any_number(actual) do
    if is_integer(actual) or is_float(actual) do
      nil
    else
      :any_number
    end
  end

  @doc """
  Function which expects any range

  ## Examples
  ```
  iex> Outstand.any_range(0..25//5)
  nil
  iex> Outstand.any_range(5)
  :any_range
  iex> Outstand.any_range(nil)
  :any_range
  ```
  """
  @spec any_range(any()) :: :any_range | nil
  def any_range(actual) do
    case actual do
      _first.._last//_step ->
        nil

      _ ->
        :any_range
    end
  end

  @doc """
  Function which expects any tuple

  ## Examples
  ```
  iex> Outstand.any_tuple({:a, :b, :c})
  nil
  iex> Outstand.any_tuple([:a])
  :any_tuple
  iex> Outstand.any_tuple(nil)
  :any_tuple
  ```
  """
  @spec any_tuple(any()) :: :any_tuple | nil
  def any_tuple(actual) do
    if is_tuple(actual) do
      nil
    else
      :any_tuple
    end
  end

  @doc """
  Function which expects current date

  ## Examples
  ```
  iex> today = DateTime.utc_now() |> DateTime.to_date()
  iex> Outstand.current_date(today)
  nil
  iex> Outstand.current_date(today |> Date.add(1))
  :current_date
  iex> Outstand.current_date(today |> Date.add(-1))
  :current_date
  iex> Outstand.current_date(nil)
  :current_date
  ```
  """
  @spec current_date(any()) :: :current_date | nil
  def current_date(actual) do
    case actual do
      %Date{} ->
        case Date.compare(actual, DateTime.utc_now() |> DateTime.to_date()) do
          :eq ->
            nil

          _ ->
            :current_date
        end

      _ ->
        :current_date
    end
  end

  @doc """
  Function which expects current date time (+/- 1 min from now)

  ## Examples
  ```
  iex> now = DateTime.utc_now()
  iex> Outstand.current_date_time(now)
  nil
  iex> Outstand.current_date_time(now |> DateTime.add(2, :minute))
  :current_date_time
  iex> Outstand.current_date_time(now |> DateTime.add(-2, :minute))
  :current_date_time
  iex> Outstand.current_date_time(nil)
  :current_date_time
  ```
  """
  @spec current_date_time(any()) :: :current_date_time | nil
  def current_date_time(actual) do
    case actual do
      %DateTime{} ->
        if DateTime.after?(actual, DateTime.utc_now() |> DateTime.add(-1, :minute)) &&
             DateTime.before?(actual, DateTime.utc_now() |> DateTime.add(1, :minute)) do
          nil
        else
          :current_date_time
        end

      _ ->
        :current_date_time
    end
  end

  @doc """
  Function which expects current naive date time (+/- 1 min from now)

  ## Examples
  ```
  iex> now = DateTime.utc_now() |> DateTime.to_naive()
  iex> Outstand.current_naive_date_time(now)
  nil
  iex> Outstand.current_naive_date_time(now |> NaiveDateTime.add(2, :minute))
  :current_naive_date_time
  iex> Outstand.current_naive_date_time(now |> NaiveDateTime.add(-2, :minute))
  :current_naive_date_time
  iex> Outstand.current_naive_date_time(nil)
  :current_naive_date_time
  ```
  """
  @spec current_naive_date_time(any()) :: :current_naive_date_time | nil
  def current_naive_date_time(actual) do
    case actual do
      %NaiveDateTime{} ->
        if NaiveDateTime.after?(actual, DateTime.utc_now() |> DateTime.to_naive() |> NaiveDateTime.add(-1, :minute)) &&
             NaiveDateTime.before?(actual, DateTime.utc_now() |> DateTime.to_naive() |> NaiveDateTime.add(1, :minute)) do
          nil
        else
          :current_naive_date_time
        end

      _ ->
        :current_naive_date_time
    end
  end

  @doc """
  Function which expects current time (+/- 1 min from now)

  ## Examples
  ```
  iex> now = DateTime.utc_now() |> DateTime.to_time()
  iex> Outstand.current_time(now)
  nil
  iex> Outstand.current_time(now |> Time.add(2, :minute))
  :current_time
  iex> Outstand.current_time(now |> Time.add(-2, :minute))
  :current_time
  iex> Outstand.current_time(nil)
  :current_time
  ```
  """
  @spec current_time(any()) :: :current_time | nil
  def current_time(actual) do
    case actual do
      %Time{} ->
        if Time.after?(actual, DateTime.utc_now() |> DateTime.to_time() |> Time.add(-1, :minute)) &&
             Time.before?(actual, DateTime.utc_now() |> DateTime.to_time() |> Time.add(1, :minute)) do
          nil
        else
          :current_time
        end

      _ ->
        :current_time
    end
  end

  @doc """
  Function which expects empty list

  ## Examples
  ```
  iex> Outstand.empty_list([])
  nil
  iex> Outstand.empty_list([:a])
  :empty_list
  iex> Outstand.empty_list(nil)
  :empty_list
  ```
  """
  @spec empty_list(any()) :: :empty_list | nil
  def empty_list(actual) do
    if is_list(actual) && Enum.empty?(actual) do
      nil
    else
      :empty_list
    end
  end

  @doc """
  Function which expects empty map

  ## Examples
  ```
  iex> Outstand.empty_map(%{})
  nil
  iex> Outstand.empty_map(%{a: :a})
  :empty_map
  iex> Outstand.empty_map(nil)
  :empty_map
  ```
  """
  @spec empty_map(any()) :: :empty_map | nil
  def empty_map(actual) do
    if is_map(actual) && Enum.empty?(actual) do
      nil
    else
      :empty_map
    end
  end

  @doc """
  Function which expects empty map set

  ## Examples
  ```
  iex> Outstand.empty_map_set(MapSet.new())
  nil
  iex> Outstand.empty_map_set(MapSet.new([:a]))
  :empty_map_set
  iex> Outstand.empty_map_set(nil)
  :empty_map_set
  ```
  """
  @spec empty_map_set(any()) :: :empty_map_set | nil
  def empty_map_set(actual) do
    case actual do
      %MapSet{} ->
        if Enum.empty?(actual) do
          nil
        else
          :empty_map_set
        end

      _ ->
        :empty_map_set
    end
  end

  @doc """
  Function which expects explicit nil

  ## Examples
  ```
  iex> Outstand.explicit_nil(:explicit_nil)
  nil
  iex> Outstand.explicit_nil(nil)
  :explicit_nil
  iex> Outstand.explicit_nil(:a)
  :explicit_nil
  ```
  """
  @spec explicit_nil(any()) :: :explicit_nil | nil
  def explicit_nil(actual) do
    if actual == :explicit_nil do
      nil
    else
      :explicit_nil
    end
  end

  @doc """
  Function which expects future date

  ## Examples
  ```
  iex> today = DateTime.utc_now() |> DateTime.to_date()
  iex> Outstand.future_date(today |> Date.add(1))
  nil
  iex> Outstand.future_date(today)
  :future_date
  iex> Outstand.future_date(nil)
  :future_date
  ```
  """
  @spec future_date(any()) :: :future_date | nil
  def future_date(actual) do
    case actual do
      %Date{} ->
        if Date.after?(actual, DateTime.utc_now() |> DateTime.to_date()) do
          nil
        else
          :future_date
        end

      _ ->
        :future_date
    end
  end

  @doc """
  Function which expects future date time

  ## Examples
  ```
  iex> now = DateTime.utc_now()
  iex> Outstand.future_date_time(now |> DateTime.add(1, :minute))
  nil
  iex> Outstand.future_date_time(now)
  :future_date_time
  iex> Outstand.future_date_time(nil)
  :future_date_time
  ```
  """
  @spec future_date_time(any()) :: :future_date_time | nil
  def future_date_time(actual) do
    case actual do
      %DateTime{} ->
        if DateTime.after?(actual, DateTime.utc_now()) do
          nil
        else
          :future_date_time
        end

      _ ->
        :future_date_time
    end
  end

  @doc """
  Function which expects future naive date time

  ## Examples
  ```
  iex> now = DateTime.utc_now() |> DateTime.to_naive()
  iex> Outstand.future_naive_date_time(now |> NaiveDateTime.add(1, :minute))
  nil
  iex> Outstand.future_naive_date_time(now)
  :future_naive_date_time
  iex> Outstand.future_naive_date_time(nil)
  :future_naive_date_time
  ```
  """
  @spec future_naive_date_time(any()) :: :future_naive_date_time | nil
  def future_naive_date_time(actual) do
    case actual do
      %NaiveDateTime{} ->
        if NaiveDateTime.after?(actual, DateTime.utc_now() |> DateTime.to_naive()) do
          nil
        else
          :future_naive_date_time
        end

      _ ->
        :future_naive_date_time
    end
  end

  @doc """
  Function which expects future time

  ## Examples
  ```
  iex> now = DateTime.utc_now() |> DateTime.to_time()
  iex> Outstand.future_time(now |> Time.add(1, :minute))
  nil
  iex> Outstand.future_time(now)
  :future_time
  iex> Outstand.future_time(nil)
  :future_time
  ```
  """
  @spec future_time(any()) :: :future_time | nil
  def future_time(actual) do
    case actual do
      %Time{} ->
        if Time.after?(actual, DateTime.utc_now() |> DateTime.to_time()) do
          nil
        else
          :future_time
        end

      _ ->
        :future_time
    end
  end

  @doc """
  Function which expects non empty keyword

  ## Examples
  ```
  iex> Outstand.non_empty_keyword([a: :a])
  nil
  iex> Outstand.non_empty_keyword([])
  :non_empty_keyword
  iex> Outstand.non_empty_keyword(nil)
  :non_empty_keyword
  ```
  """
  @spec non_empty_keyword(any()) :: :non_empty_keyword | nil
  def non_empty_keyword(actual) do
    if actual != [] and Keyword.keyword?(actual) do
      nil
    else
      :non_empty_keyword
    end
  end

  @doc """
  Function which expects non empty list

  ## Examples
  ```
  iex> Outstand.non_empty_list([:a])
  nil
  iex> Outstand.non_empty_list([])
  :non_empty_list
  iex> Outstand.non_empty_list(nil)
  :non_empty_list
  ```
  """
  @spec non_empty_list(any()) :: :non_empty_list | nil
  def non_empty_list(actual) do
    if is_list(actual) && !Enum.empty?(actual) do
      nil
    else
      :non_empty_list
    end
  end

  @doc """
  Function which expects non empty map

  ## Examples
  ```
  iex> Outstand.non_empty_map(%{a: :a})
  nil
  iex> Outstand.non_empty_map(%{})
  :non_empty_map
  iex> Outstand.non_empty_map(nil)
  :non_empty_map
  ```
  """
  @spec non_empty_map(any()) :: :non_empty_map | nil
  def non_empty_map(actual) do
    if is_map(actual) && !Enum.empty?(actual) do
      nil
    else
      :non_empty_map
    end
  end

  @doc """
  Function which expects non empty map set

  ## Examples
  ```
  iex> Outstand.non_empty_map_set(MapSet.new([:a]))
  nil
  iex> Outstand.non_empty_map_set(MapSet.new())
  :non_empty_map_set
  iex> Outstand.non_empty_map_set(nil)
  :non_empty_map_set
  ```
  """
  @spec non_empty_map_set(any()) :: :non_empty_map_set | nil
  def non_empty_map_set(actual) do
    case actual do
      %MapSet{} ->
        if !Enum.empty?(actual) do
          nil
        else
          :non_empty_map_set
        end

      _ ->
        :non_empty_map_set
    end
  end

  @doc """
  Function which expects any not nil atom

  ## Examples
  ```
  iex> Outstand.non_nil_atom(:a)
  nil
  iex> Outstand.non_nil_atom(nil)
  :non_nil_atom
  iex> Outstand.non_nil_atom("a")
  :non_nil_atom
  ```
  """
  @spec non_nil_atom(any()) :: :non_nil_atom | nil
  def non_nil_atom(actual) do
    if actual != nil && is_atom(actual) do
      nil
    else
      :non_nil_atom
    end
  end

  @doc """
  Function which expects past date

  ## Examples
  ```
  iex> Outstand.past_date(~D[2002-02-25])
  nil
  iex> Outstand.past_date(~D[2102-02-25])
  :past_date
  iex> Outstand.past_date(nil)
  :past_date
  ```
  """
  @spec past_date(any()) :: :past_date | nil
  def past_date(actual) do
    case actual do
      %Date{} ->
        if Date.before?(actual, DateTime.utc_now() |> DateTime.to_date()) do
          nil
        else
          :past_date
        end

      _ ->
        :past_date
    end
  end

  @doc """
  Function which expects past date time

  ## Examples
  ```
  iex> Outstand.past_date_time(~U[2002-02-25 11:59:00.00Z])
  nil
  iex> Outstand.past_date_time(~U[2102-02-25 11:59:00.00Z])
  :past_date_time
  iex> Outstand.past_date_time(nil)
  :past_date_time
  ```
  """
  @spec past_date_time(any()) :: :past_date_time | nil
  def past_date_time(actual) do
    case actual do
      %DateTime{} ->
        if DateTime.before?(actual, DateTime.utc_now()) do
          nil
        else
          :past_date_time
        end

      _ ->
        :past_date_time
    end
  end

  @doc """
  Function which expects past naive date time

  ## Examples
  ```
  iex> Outstand.past_naive_date_time(~N[2002-02-25 11:59:00])
  nil
  iex> Outstand.past_naive_date_time(~N[2102-02-25 11:59:00])
  :past_naive_date_time
  iex> Outstand.past_naive_date_time(nil)
  :past_naive_date_time
  ```
  """
  @spec past_naive_date_time(any()) :: :past_naive_date_time | nil
  def past_naive_date_time(actual) do
    case actual do
      %NaiveDateTime{} ->
        if NaiveDateTime.before?(actual, DateTime.utc_now() |> DateTime.to_naive()) do
          nil
        else
          :past_naive_date_time
        end

      _ ->
        :past_naive_date_time
    end
  end

  @doc """
  Function which expects past time

  ## Examples
  ```
  iex> Outstand.past_time(~T[00:00:00.000])
  nil
  iex> Outstand.past_time(~T[23:59:59.999])
  :past_time
  iex> Outstand.past_time(nil)
  :past_time
  ```
  """
  @spec past_time(any()) :: :past_time | nil
  def past_time(actual) do
    case actual do
      %Time{} ->
        if Time.before?(actual, DateTime.utc_now() |> DateTime.to_time()) do
          nil
        else
          :past_time
        end

      _ ->
        :past_time
    end
  end

  @spec all_of(maybe_improper_list(), any()) :: nil | :all_of
  @doc """
  Function which expects all elements in expected list to be resolved by an element from actual list

  ## Examples
  ```
  iex> Outstand.all_of([1, 2, 3], [3, 1, 2])
  nil
  iex> Outstand.all_of([1, 2, 3], [1])
  :all_of
  iex> Outstand.all_of([1, 2, 3], nil)
  :all_of
  ```
  """
  def all_of(expected, actual) when is_list(expected) do
    case is_list(actual) and Enum.all?(expected, &Outstand.nil_outstanding?(Outstand.any_of_actual_list(&1, actual))) do
      true -> nil
      _ -> :all_of
    end
  end

  @spec any_of(maybe_improper_list(), any()) :: nil | :any_of
  @doc """
  Function which expects at least one element in expected list to be resolved by actual

  ## Examples
  ```
  iex> Outstand.any_of([1, 2, 3], 1)
  nil
  iex> Outstand.any_of([1, 2, 3], 0)
  :any_of
  iex> Outstand.any_of([1, 2, 3], nil)
  :any_of
  ```
  """
  def any_of(expected, actual) when is_list(expected) do
    case Enum.any?(expected, &Outstand.nil_outstanding?(&1, actual)) do
      true -> nil
      _ -> :any_of
    end
  end

  @spec none_of(maybe_improper_list(), any()) :: nil | :none_of
  @doc """
  Function which expects no element in expected list to be resolved by actual

  ## Examples
  ```
  iex> Outstand.none_of([1, 2, 3], 0)
  nil
  iex> Outstand.none_of([1, 2, 3], 1)
  :none_of
  iex> Outstand.none_of([1, 2, 3], nil)
  nil
  ```
  """
  def none_of(expected, actual) when is_list(expected) do
    case Enum.count(Enum.map(expected, &Outstand.nil_outstanding?(&1, actual)), fn x -> x end) do
      0 -> nil
      _ -> :none_of
    end
  end

  @spec one_of(maybe_improper_list(), any()) :: nil | :one_of
  @doc """
  Function which expects exactly one element in expected list to be resolved by actual

  ## Examples
  ```
  iex> Outstand.one_of([1, 2, 3], 1)
  nil
  iex> Outstand.one_of([1, 1, 3], 1)
  :one_of
  iex> Outstand.one_of([1, 2, 3], nil)
  :one_of
  ```
  """
  def one_of(expected, actual) when is_list(expected) do
    case Enum.count(Enum.map(expected, &Outstand.nil_outstanding?(&1, actual)), fn x -> x end) do
      1 -> nil
      _ -> :one_of
    end
  end

  @spec less_than(Duration.t(), any()) :: nil | :less_than
  @doc """
  Function which expects actual to be less than the value

  ## Examples
  ```
  iex> Outstand.less_than(%Duration{hour: 2}, %Duration{hour: 1})
  nil
  iex> Outstand.less_than(%Duration{hour: 1}, %Duration{hour: 1})
  :less_than
  iex> Outstand.less_than(%Duration{hour: 1}, nil)
  :less_than
  ```
  """
  def less_than(expected, actual) when is_struct(expected, Duration) do
    cond do
      actual == nil ->
        :less_than

      true ->
        now = DateTime.utc_now()

        case DateTime.compare(DateTime.shift(now, actual), DateTime.shift(now, expected)) do
          :lt -> nil
          _ -> :less_than
        end
    end
  end

  @spec greater_than(Duration.t(), any()) :: nil | :longer_than
  @doc """
  Function which expects actual to be greater than the value

  ## Examples
  ```
  iex> Outstand.greater_than(%Duration{hour: 1}, %Duration{hour: 2})
  nil
  iex> Outstand.greater_than(%Duration{hour: 1}, %Duration{hour: 1})
  :greater_than
  iex> Outstand.greater_than(%Duration{hour: 1}, nil)
  :greater_than
  ```
  """
  def greater_than(expected, actual) when is_struct(expected, Duration) do
    cond do
      actual == nil ->
        :greater_than

      true ->
        now = DateTime.utc_now()

        case DateTime.compare(DateTime.shift(now, actual), DateTime.shift(now, expected)) do
          :gt -> nil
          _ -> :greater_than
        end
    end
  end

  @spec bounded_by(maybe_improper_list(), any()) :: nil | :bounded_by | :error
  @doc """
  Function which expects actual to be bounded by the listed min and max values

  ## Examples
  ```
  iex> Outstand.bounded_by([%Duration{hour: 1}, %Duration{minute: 90}], %Duration{minute: 70})
  nil
  iex> Outstand.bounded_by([%Duration{hour: 1}, %Duration{minute: 90}], %Duration{minute: 50})
  :bounded_by
  iex> Outstand.bounded_by([%Duration{hour: 1}, %Duration{minute: 90}], %Duration{hour: 2})
  :bounded_by
  iex> Outstand.bounded_by([%Duration{hour: 1}, %Duration{minute: 90}], nil)
  :bounded_by
  ```
  """
  def bounded_by(expected, actual) when is_list(expected) do
    cond do
      actual == nil ->
        :bounded_by

      length(expected) != 2 ->
        :error

      true ->
        now = DateTime.utc_now()
        min = DateTime.shift(now, hd(expected))
        max = DateTime.shift(now, hd(tl(expected)))
        shifted = DateTime.shift(now, actual)

        cond do
          DateTime.before?(shifted, min) or DateTime.after?(shifted, max) ->
            :bounded_by

          true ->
            nil
        end
    end
  end

  @spec unbounded_by(maybe_improper_list(), any()) :: nil | :bounded_by | :error
  @doc """
  Function which expects actual not to be bounded by the listed min and max values

  ## Examples
  ```
  iex> Outstand.unbounded_by([%Duration{hour: 1}, %Duration{minute: 90}], %Duration{minute: 30})
  nil
  iex> Outstand.unbounded_by([%Duration{hour: 1}, %Duration{minute: 90}], %Duration{hour: 2})
  nil
  iex> Outstand.unbounded_by([%Duration{hour: 1}, %Duration{minute: 90}], %Duration{minute: 70})
  :unbounded_by
  iex> Outstand.unbounded_by([%Duration{hour: 1}, %Duration{minute: 90}], nil)
  :unbounded_by
  ```
  """
  def unbounded_by(expected, actual) when is_list(expected) do
    cond do
      actual == nil ->
        :unbounded_by

      length(expected) != 2 ->
        :error

      true ->
        now = DateTime.utc_now()
        min = DateTime.shift(now, hd(expected))
        max = DateTime.shift(now, hd(tl(expected)))
        shifted = DateTime.shift(now, actual)

        cond do
          DateTime.before?(shifted, min) or DateTime.after?(shifted, max) ->
            nil

          true ->
            :unbounded_by
        end
    end
  end

  @spec any_of_actual_list(any(), any()) :: any()
  @doc """
  Function which expects at least one element from actual list to resolve expected

  ## Examples
  ```
  iex> Outstand.any_of_actual_list(1, [1,2,3])
  nil
  iex> Outstand.any_of_actual_list(1, [2, 3])
  1
  iex> Outstand.any_of_actual_list(1, nil)
  1
  ```
  """
  def any_of_actual_list(expected, actual) do
    case is_list(actual) && Enum.any?(actual, &Outstand.nil_outstanding?(expected, &1)) do
      true -> nil
      _ -> expected
    end
  end

  @doc """
  Converts term to struct if a map

  ## Examples
  ```
  iex> today = DateTime.utc_now() |> DateTime.to_date()
  iex> today_map = Map.delete(today, :__struct__)
  iex> assert today == Outstand.map_to_struct(today_map, Date)
  iex> Outstand.map_to_struct(nil, Date)
  nil
  ```
  """
  @spec map_to_struct(any() | nil, bitstring()) :: any()
  def map_to_struct(term, name) do
    if is_map(term) do
      struct(name, term)
    else
      term
    end
  end

  @doc """
  Suppress outstanding result when list of nils, empty list, map, map set or tuple

  ## Examples

  ```
  iex> Outstand.suppress([nil, nil])
  nil
  iex> Outstand.suppress([])
  nil
  iex> Outstand.suppress([:a])
  [:a]
  iex> Outstand.suppress(%{})
  nil
  iex> Outstand.suppress(%{x: :a})
  %{x: :a}
  iex> Outstand.suppress(MapSet.new())
  nil
  iex> Outstand.suppress(MapSet.new([:a]))
  MapSet.new([:a])
  iex> Outstand.suppress({})
  nil
  iex> Outstand.suppress({:a})
  {:a}
  ```
  """
  def suppress(map) when is_map(map) do
    if Enum.empty?(map) do
      nil
    else
      map
    end
  end

  def suppress(list) when is_list(list) do
    nils_removed = Enum.reject(list, &is_nil(&1))

    if Enum.empty?(nils_removed) do
      nil
    else
      list
    end
  end

  def suppress(tuple) when is_tuple(tuple) do
    if tuple_size(tuple) == 0 do
      nil
    else
      tuple
    end
  end

  def suppress(atom) when is_nil(atom) do
    nil
  end

  @doc """
  Calculates outstanding on two maps

  ## Examples

  ```
  iex> Outstand.outstanding_map(%{}, %{})
  nil
  iex> Outstand.outstanding_map(%{a: 1}, %{b: 2})
  %{a: 1}
  iex> Outstand.outstanding_map(%{a: 1}, %{a: 2})
  %{a: 1}
  iex> Outstand.outstanding_map(%{a: 1}, %{a: 1, b: 2})
  nil
  ```
  """
  def outstanding_map(expected, actual) when is_map(expected) and is_map(actual) do
    expected
    |> Enum.reduce(
      %{},
      fn {key, expected_value}, acc ->
        if (not Map.has_key?(actual, key) and key == :no_value) or
             Outstanding.outstanding(expected_value, actual[key]) != nil do
          Map.put(acc, key, Outstanding.outstanding(expected_value, actual[key]))
        else
          acc
        end
      end
    )
    |> Outstand.suppress()
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
  Atom
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
  iex> Outstand.type_of([a: %{a: "a", b: "b"}])
  List
  iex> Outstand.type_of(%{a: :a})
  Map
  iex> Outstand.type_of(MapSet.new([:a]))
  MapSet
  iex> Outstand.type_of(0..25//5)
  Range
  iex> Outstand.type_of({:a, :b, :c})
  Tuple
  iex> Outstand.type_of({:a, %{a: "a", b: "b"}})
  Tuple
  iex> Outstand.type_of(~U[2025-02-25 11:59:00.00Z])
  DateTime
  iex> Outstand.type_of(~D[2025-02-25])
  Date
  iex> Outstand.type_of(self())
  Other
  ```
  """
  @spec type_of(any()) :: module()
  def type_of(term) do
    case term do
      _first.._last//_step ->
        Range

      %MapSet{} ->
        MapSet

      %_{} ->
        term.__struct__

      _ ->
        cond do
          is_atom(term) -> Atom
          is_bitstring(term) -> BitString
          is_float(term) -> Float
          is_function(term) -> Function
          is_integer(term) -> Integer
          is_list(term) -> List
          is_map(term) -> Map
          is_tuple(term) -> Tuple
          true -> Other
        end
    end
  end
end
