# Outstanding

Outstanding: something not yet dealt with.

The outstanding protocol is for those times when you want to know if any or which expectations have not been sufficiently met, and equality doesn't actually do it for you.

We have two terms, `expected` and  `actual`, apply `outstanding(expected, actual)` and see if nothing is outstanding `nil`, or we get back what is `outstanding` for us to work on.

Outstanding implementations are provided for most types, as well as helper functions to make it easy to add implementations for your structs. Outstanding implementations which accept expected Functions are provided, providing a point of extensibility. Convenience expected functions are also provided.

```elixir
iex> import Outstanding
iex> outstanding(%{x: :a, y: :b}, %{})
%{y: :b, x: :a}
iex> outstanding(%{x: :a, y: :b}, %{y: :b})
%{x: :a}
iex> outstanding(%{x: :a, y: :b}, %{x: :a, y: :b})
nil
iex> outstanding(%{x: :a, y: :b}, %{x: :a, y: :b, z: :c})
nil
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `outstanding` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:outstanding, "~> 0.3.0"}
  ]
end
```

## Tutorial

To get started you need a running instance of [Livebook](https://livebook.dev/)

[![Run in Livebook](https://livebook.dev/badge/v1/blue.svg)](https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2Fdiffo-dev%2Foutstanding%2Fblob%2Fdev%2Foutstanding.livemd)

## Outstanding?

Outstanding.outstanding? simply calls Outstanding.outstanding, and is true if anything is outstanding, or false if nil outstanding.

```elixir
iex> import Outstanding
iex> outstanding?(%{x: :a, y: :b}, %{y: :b})
true
iex> outstanding?(%{x: :a, y: :b}, %{x: :a, y: :b})
false
```

## Supported Types

Out of the box we have outstanding protocol implementations for the following types:

| Elixir Type Module | Type Example               | Notes               | Resolving Types              | Related Expected Functions                                            |
|--------------------|----------------------------|---------------------|------------------------------|-----------------------------------------------------------------------|
| Atom               | :a                         | nil is an Atom      | Atom                         | any_atom, non_nil_atom                                                |
| BitString          | "a"                        |                     | BitString                    | any_bitstring                                                         |
| Boolean            | true                       |                     | Boolean                      | any_boolean                                                           |
| Date               | ~D[2025-02-25]             |                     | Date                         | any_date, current_date, future_date, past_date                        |
| DateTime           | U[2025-02-25 11:59:00.00Z] |                     | DateTime                     | any_date_time, current_date_time, future_date_time, past_date_time    |
| Duration           | %Duration{minute: 60}      |                     | Duration                     | any_duration                                                          |
| Float              | 1.1                        |                     | Float, Integer               | any_float, any_number                                                 |
| Function           | &Outstand.non_nil_atom/1   | actual is argument  | Any                          | -                                                                     |
| Integer            | 1                          |                     | Integer, Float, Range        | any_integer, any_number                                               |
| Keyword            | [a: :a]                    | handled by List     | (Keyword) List               | non_empty_keyword                                                     |
| List               | [:a]                       |                     | List                         | any_list, empty_list, non_empty_list                                  |
| MapSet             | MapSet.new([:a])           | uses difference     | MapSet                       | any_map_set, empty_map_set, non_empty_map_set                         |
| Map                | {a: :b, c: :d}             | strict              | Map, any Struct              | any_map, empty_map, non_empty_map                                     |
| NaiveDateTime      | ~N[2025-02-25 11:59:00]    |                     | NaiveDateTime                | any_naive_date_time, future_time, current_time, past_time             |
| Range              | 1                          |                     | Range, Integer               | any_range                                                             |
| Regex              | ~r/foo/                    | actual is argument  | String.Chars implementations | -                                                                     |
| Time               | ~T[11:59:00.000]           |                     | Time                         | any_time, current_time, future_time, past_time                        |
| Tuple              | {a: :b}                    | handled by Any      | Tuple                        | any_tuple                                                             |

Maps call outstanding on each element is expected, but allow extra elements in actual. Maps can also be resolved by Structs.

Keywords are Lists of Tuples but are handled like Maps.

Lists (other than Keywords) are strict in that they must be in order, so lists must have the same number of elements for outstanding to be nil. Outstanding is attempted on each pair of expected/actual elements, even when they have unequal number, in order to return a list of resolved (nil) or outstanding elements. If all expected elements are resolved however there are extra actual elements a list of nils is returned, of length expected.

MapSets are not strict in that actual may contain additional elements, however MapSet.difference is used on the elements (which uses equals not outstanding).

Tuples not part of Keywork List are matched using Any, which uses equals.

Date, Time, DateTime and NaiveDateTime are supported, where Expected Function current_date matches today's date, other current times are now +/- 1 min.

Function must be an outstanding function which takes a single argument actual, such as the expected functions.

Regex can be any regex operating on the actual BitString, uses Regex.match?

Of course you can easily implement the outstanding protocol for your own type (especially structs) using the defoutstanding macro.

## Expected Functions
Sometimes our expectation is a bit vague, for instance in the example above we initially did not know the id. We can supply a function as an expectation, when not met this supplies a corresponding atom.

An expected function of arity 1 implicitly has actual as the argument.

```elixir
iex> import Outstanding
Outstanding
iex> use Outstand
Outstand

iex> outstanding(&Outstand.any_integer/1, 546)
nil
iex> outstanding(&Outstand.any_integer/1, nil)
:any_integer

```

&Outstand.any_integer/1 is one of many convenience functions in Outstand.
```elixir
  @spec any_integer(any()) :: :any_integer | nil
  def any_integer(actual) do
    if is_integer(actual) do
      nil
    else
      :any_integer
    end
  end
```

There are are number of included expected functions, see the table in Supported Types for the types they relate to.

Expected functions of arity 2 are also supported. These have the form of a tuple of function and term, where term is an argument or argument list.

| Expected Function | Expected Type           | Resolving Types         | Behaviour                                                                             |
|-------------------|-------------------------|-------------------------|---------------------------------------------------------------------------------------|
| all_of            | List, Map, Keyword List | List, Map, Keyword List | expects all expected elements to be resolved by any actual element                    |
| any_of            | List, Map, Keyword List | Any                     | expects at least one expected element to be resolved by actual                        |
| none_of           | List, Map, Keyword List | List, Map, Keyword List | expects no expected elements to be resolved by any actual element                     |
| one_of            | List, Map, Keyword List | List, Map, Keyword List | expects exactly one expected element to be resolved by any actual element             |
| less_than         | Duration                | Duration                | expects actual to be less than value                                                  |
| greater_than      | Duration                | Duration                | expects actual to be greater than value                                               |
| bounded_by        | Duration                | Duration                | expects actual to be bounded by [min_value, max_value]                                |
| unbounded_by      | Duration                | Duration                | expects actual to be not bounded by [min_value, max_value]                            |

You can supply your own functions where needed.

### Exceeds and Difference Operators

For convenient use in expressions we've implemented operators.

The 'exceeds' operator tells us whether our expectations exceed our actual. ```expected >>> actual``` is equivalent to ```Outstanding.outstanding?(expected, actual)```

The 'difference' operator tells us what expectations remain unmet. ```expected --- actual``` is equivalent to ```Outstanding.outstanding(expected, actual)```

Example of infix shortcuts usage:

```elixir
iex> use Outstand
Outstand

iex> [:a, :b] --- [:a, :b]
nil
iex> [:a, :b] >>> [:a, :b]
false
iex> %{x: :a, y: :b} >>> %{y: :b}
true
iex> %{x: :a, y: :b} --- %{y: :b}
%{x: :a}
```

## Expecting Anything or Nothing
We've taken a nil expectation to mean that we have no expectations, so are satisified by actual anything.

However we often need to expect actual nothing, say we managed something that shouldn't exist now, and we want to check for this.
We have two alternatives for this. In the first we can expect :explicit_nil which is only satisfied with :explicit_nil:

```elixir
iex> Outstanding.outstanding(:explicit_nil, :explicit_nil)
nil
iex> Outstanding.outstanding(:explicit_nil, "a")
:explicit_nil
iex> Outstanding.outstanding(:explicit_nil, nil)
:explicit_nil
```
There is a helper function &Outstand.explicit_nil/1, but it behaves identically. The disadvantage here is that actual needs to be coded with :explicit_nil, rather than nil or simply missing keys, which requires transformation of actual ahead of differencing with outstanding.

Another alternative is the :no_value atom, which is only used as an expected value, where the expectation is a key-value, such as a Map or Keyword List element. It expects that there is no value, either due to there being no key, or the key having a value of nil. This can be very useful as we can avoid an actual transformation. The no_value expectation can be resolved by actual :no_value or nil.

```elixir
iex> Outstanding.outstanding(%{a: :no_value}, %{})
nil
iex> Outstanding.outstanding(%{a: :no_value}, %{a: nil})
nil
iex> Outstanding.outstanding(%{a: :no_value}, %{a: "a"})
%{a: :no_value}
iex> Outstanding.outstanding([a: :no_value], [])
nil
iex> Outstanding.outstanding([a: :no_value], [a: nil])
nil
iex> Outstanding.outstanding([a: :no_value], [a: "a"])
[a: :no_value]
iex> Outstanding.outstanding(:no_value, :no_value)
nil
iex> Outstanding.outstanding(:no_value, nil)
nil
iex> Outstanding.outstanding(:no_value, "a")
:no_value
```

## Implementing Outstanding for other types

This requires some though as to what it means to 'resolve' your expected type with actual. 

## derive for Structs
Outstanding implements the ```__deriving__/3``` callback so you can simply derive an Outstanding implementation when you define your struct. By default this performs outstanding on all fields, and requires the actual struct to be of the same type.

```elixir
defmodule ABC do
  @derive Outstanding
  defstruct [:a, :b, :c]
end
```

You can also exclude fields with the ```except``` option

```elixir
  defmodule AB do
    @derive {Outstanding, except: [:c]}
    defstruct [:a, :b, :c]
  end
```

## defoutstanding macro

More flexibly, the defoutstanding macro can be used to implement outstanding on other types, including your own structs.

```elixir
use Outstand

defmodule XYZ do
  defstruct [:x, :y, :z]
end

defoutstanding expected :: XYZ, actual :: Any do
  case {expected, actual} do
    {nil, nil} ->
      nil
    {_, ^expected} ->
      nil
    {%name{}, %name{}} ->
      expected
      |> Map.from_struct()
      |> Outstanding.outstanding(Map.from_struct(actual))
      |> Outstand.map_to_struct(name)
    {_, _} ->
      # not an exact match so default to outstanding
      expected
  end
end
```

If you are using Ash, then consider using the [ash_outstanding](https://github.com/diffo-dev/ash_outstanding) extension which enables you to implement Outstanding protocol on your Ash Resources with a simple DSL.

## Testing

`use Outstand` expression also provides 3 utilities which can auto-generate ExUnit tests for implementation of `Outstanding` protocol for your types:

```elixir
iex>use Outstand

iex> gen_something_outstanding_test("value outstanding", "a", "b")
iex> gen_nothing_outstanding_test("realized", "a", "a")
iex> gen_result_outstanding_test("value result", "a", "b", "a")
```

## Example

We often have minimum expectations that must be met, which when not met by actuality are `outstanding`. However we may also be happy for these expectations to be exceeded.

We may expect something to exist, but we may not know its identifier yet. If we have a list of managed child services, and imagine a scenario where while our backup feature is enabled, we should have a backup child service, however before we acquire it we won't know its identity.

| scenario                          | expected                                 | actual                                         | outstanding? | outstanding                     |
|-----------------------------------|------------------------------------------|------------------------------------------------|--------------|---------------------------------|
| no backup                         | []                                       | []                                             | false        | nil                             |
| enable backup - commmenced        | [%{alias: :backup, state: :ok}]          | []                                             | true         | [%{alias: :backup, state: :ok}] |
| enable backup - backup created    | [%{alias: :backup, state: :ok}]          | [%{alias: :backup, id: 453, state: :starting}] | true         | [%{alias: :backup, state: :ok}] |
| enable backup - backup bound      | [%{alias: :backup, id: 453, state: :ok}] | [%{alias: :backup, id: 453, state: :ok}]       | false        | nil                             |
 
Once we've created a backup child we want to keep track of it, so we refine the expectation to include it's specific id. We also monitor its behaviour and apply corrective action, just like a real child.

An application using outstanding would update expected, then do work based on what is outstanding given actual.Outstanding can be further processed (by your code) to detemine next action based on your priority of goals not met, constraints, business rules, etc. 

## Acknowledgements

Thanks to Ilja Tkachuk for [comparable](https://github.com/coingaming/comparable) which was an exemplar.

Kudos to the [Elixir Core Team](https://elixir-lang.org/) for [elixir](https://github.com/elixir-lang/elixir) 🚀

## Links
[Diffo.dev](https://www.diffo.dev)

[ash_outstanding](https://github.com/diffo-dev/ash_outstanding)

[documentation](<https://hexdocs.pm/outstanding/readme.html>)

