# Outstanding

Outstanding, not as in 'the scarecrow was outstanding in his field', rather outstanding as in something not yet dealt with.

The outstanding protocol is for those times when you want to know if any or which expectations have not been sufficiently met, and equality doesn't actually do it for you.

We have two terms, `expected` and  `actual`, apply `outstanding(expected, actual)` and see if nothing is outstanding `nil`, or we get back what is `outstanding` for us to work on.

Outstanding implementations are provided for most types, as well as helper functions to make it easy to add support for your structs.

```elixir
iex> Outstand.outstanding(%{x: :a, y: :b}, %{})
%{y: :b, x: :a}

iex> Outstand.outstanding(%{x: :a, y: :b}, %{y: :b})
%{x: :a}

iex> Outstand.outstanding(%{x: :a, y: :b}, %{x: :a, y: :b})
nil

iex> Outstand.outstanding(%{x: :a, y: :b}, %{x: :a, y: :b, z: :c})
nil
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `outstanding` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:outstanding, "~> 0.1.0"}
  ]
end
```

## Real example

We often have minimum expectations that must be met, which when not met by actuality are `outstanding`. However we may also be happy for these expectations to be exceeded.

We may expect something to exist, but we may not know its identifier yet. If we have a list of managed child services, and imagine a scenario where while our backup feature is enabled, we should have a backup child service, however before we acquire it we won't know its identity.

| scenario                          | expected                                 | actual                                         | outstanding? | outstanding                     |
| no backup                         | []                                       | []                                             | false        | nil                             |
| enable backup - commmenced        | [%{alias: :backup, state: :ok}]          | []                                             | true         | [%{alias: :backup, state: :ok}] |
| enable backup - backup created    | [%{alias: :backup, state: :ok}]          | [%{alias: :backup, id: 453, state: :starting}] | true         | [%{alias: :backup, state: :ok}] |
| enable backup - backup bound      | [%{alias: :backup, id: 453, state: :ok}] | [%{alias: :backup, id: 453, state: :ok}]       | false        | nil                             |

## Utilities

`use Outstand` expression provides infix shortcuts for outstanding
Also it provides infix shortcuts for these utilities:

| Outstand.fn/2                           | Outstand infix shortcut | returns                | memory aid               |
|-----------------------------------------|-------------------------|------------------------|--------------------------|
| Outstand.outstanding(expected, actual)  | expected --- actual     | nil or Outstanding.t() | expected less actual     |
| Outstand.outstanding?(expected, actual) | expected >>> actual     | boolean                | expected exceeds actual? |

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

## Testing

`use Outstand` expression also provides 3 utilities which can auto-generate tests for implementation of `Outstanding` protocol for your types:

```elixir
iex>use Outstand

iex> gen_something_outstanding_test("value outstanding", "a", "b")
iex> gen_nothing_outstanding_test("realized", "a", "a")
iex> gen_result_outstanding_test("value result", "a", "b", "a")
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/outstanding>.

