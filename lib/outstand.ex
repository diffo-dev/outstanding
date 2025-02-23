defmodule Outstand do
  @moduledoc """
  Provides utilities to implement and work with `Outstanding` types
  """

  @type expected:: term
  @type actual :: term

  @doc """
  Enables infix `---`, `<<<` shortcuts, `defoutstanding`,
  `gen_nothing_outstanding_test`, `gen_something_outstanding_test` `gen_result_outstanding_test` macro
  """
  defmacro __using__(_) do
    quote do
      require Outstand

      import Outstand,
        only: [
          ---: 2,
          <<<: 2,
          defoutstanding: 3,
          gen_nothing_outstanding_test: 3,
          gen_something_outstanding_test: 3,
          gen_result_outstanding_test: 4
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
  ...>   defoutstanding %Foo{value: expected} :: Foo, %Foo{value: actual} :: Foo do
  ...>     Outstand.outstanding(expected, actual)
  ...>   end
  ...>   defoutstanding %Foo{value: expected} :: Foo, %Bar{value: actual} :: Bar do
  ...>     Outstand.outstanding(expected, actual)
  ...>   end
  ...>   defoutstanding %Foo{value: expected} :: Foo, actual :: Integer do
  ...>     Outstand.outstanding(expected, actual)
  ...>   end
  ...> end
  ...> |> Code.compile_quoted
  iex> quote do
  ...>   expected = %Foo{value: 1, meta: 1}
  ...>   actual = %Foo{value: 1, meta: 2}
  ...>   Outstand.outstanding(expected, actual)
  ...> end
  ...> |> Code.eval_quoted
  ...> |> elem(0)
  nil
  iex> quote do
  ...>   expected = %Foo{value: 1, meta: 1}
  ...>   actual = %Bar{value: 1, meta: 2}
  ...>   Outstand.outstanding(expected, actual)
  ...> end
  ...> |> Code.eval_quoted
  ...> |> elem(0)
  nil
  iex> quote do
  ...>   expected = %Foo{value: 1, meta: 1}
  ...>   actual = 1
  ...>   Outstand.outstanding(expected, actual)
  ...> end
  ...> |> Code.eval_quoted
  ...> |> elem(0)
  nil
  ```
  """
  defmacro defoutstanding(
             {:"::", _, [expected_expression, quoted_expected_type]},
             {:"::", _, [actual_expression, quoted_actual_type]},
             do: code
           ) do
    {expected_type, []} = Code.eval_quoted(quoted_expected_type, [], __CALLER__)

    {actual_type, []} = Code.eval_quoted(quoted_actual_type, [], __CALLER__)

    type =
      [Outstanding, Type, expected_type, And, actual_type]
      |> Module.concat()

    quote do
      defmodule unquote(type) do
        @fields [:expected, :actual]
        @enforce_keys @fields
        defstruct @fields
      end

      defimpl Outstanding, for: unquote(type) do
        def outstanding(%unquote(type){
          expected: unquote(expected_expression),
          actual: unquote(actual_expression)
        }) do
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
        #assert outstanding(uq_expected, uq_actual) == nil
        #refute uq_expected <<< uq_actual
        #refute outstanding?(uq_expected, uq_actual)
      end
    end
  end

  defmacro gen_something_outstanding_test(name, expected, actual) do
    quote do
      test unquote(name) do
        uq_expected = unquote(expected)
        uq_actual = unquote(actual)
        assert uq_expected --- uq_actual != nil
        #assert outstanding(uq_expected, uq_actual) != nil
        #assert uq_expected <<< uq_actual
        #assert outstanding?(uq_expected, uq_actual)
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
        #assert outstanding(uq_expected, uq_actual) == uq_outstanding
        #assert uq_expected <<< uq_actual == outstanding?(uq_outstanding)
        #assert outstanding?(uq_expected, uq_actual) == outstanding?(uq_outstanding)
      end
    end
  end

  @doc """
  Infix shortcut --- for `Outstand.outstanding/2`

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
      |> Outstand.outstanding(unquote(actual))
    end
  end

  @doc """
  Infix shortcut <<< for `Outstand.outstanding?/2`

  ## Examples

  ```
  iex> use Outstand
  Outstand
  iex> 1 <<< 1
  false
  iex> 1 <<< :hello
  true
  ```
  """
  defmacro expected <<< actual do
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
  @spec outstanding?(expected, actual) :: boolean()
  def outstanding?(expected, actual) do
    outstanding?(Outstand.outstanding(expected, actual))
  end

  @doc """
  Outstanding of expected and actual term

  ## Examples

  ```
  iex> Outstand.outstanding(1, 1)
  nil
  iex> Outstand.outstanding(1, nil)
  1
  iex> Outstand.outstanding(1, 2)
  1
  ```
  """
  @spec outstanding(expected, actual) :: Outstanding.result()
  def outstanding(expected, actual) do
    expected
    |> new(actual)
    |> Outstanding.outstanding()
  end

  defp new(expected, actual) do
    #IO.inspect(Typable.type_of(expected), label: "new type_of expected")
    #IO.inspect(Typable.type_of(actual), label: "new type_of actual")
    ea_type =
      try do
        [Outstanding, Type, Typable.type_of(expected), And, Typable.type_of(actual)]
        |> Module.safe_concat()
      rescue
        ArgumentError ->
          [Outstanding, Type, Any, And, Any]
          |> Module.safe_concat()
      end

    %{__struct__: ea_type, expected: expected, actual: actual}
    #|> IO.inspect(label: "new")
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
end
