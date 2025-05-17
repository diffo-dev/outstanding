use Outstand

defoutstanding expected :: List, actual :: Any do
  case Outstand.type_of(actual) do
    List ->
      cond do
        # both empty
        expected == [] and actual == [] ->
          nil

        # keyword list
        expected != [] and Keyword.keyword?(expected) ->
          # keyword lists are treated like maps, in that extra elements are tolerated and outstanding is called on 'matching' elements
          Keyword.keys(expected)
          |> Enum.filter(fn key ->
            (key not in Keyword.keys(actual) and key == :no_value) or
              Outstanding.outstanding(expected[key], actual[key]) != nil
          end)
          |> Enum.into([], &{&1, Outstanding.outstanding(expected[&1], actual[&1])})
          |> Outstand.suppress()

        # actual not a list
        !is_list(actual) ->
          expected

        # equal size lists (may resolve outstanding)
        Enum.count(expected) == Enum.count(actual) ->
          expected
          |> Enum.zip(actual)
          |> Enum.map(&Outstanding.outstanding(elem(&1, 0), elem(&1, 1)))
          |> Outstand.suppress()

        # actual longer than expected, cannot resolve outstanding
        Enum.count(expected) <= Enum.count(actual) ->
          expected
          |> Enum.take(Enum.count(actual))
          |> Enum.zip(actual)
          |> Enum.map(&Outstanding.outstanding(elem(&1, 0), elem(&1, 1)))

        # expected longer than actual, cannot resolve outstanding
        true ->
          padded_actual = actual ++ List.duplicate(nil, Enum.count(expected) - Enum.count(actual))

          expected
          |> Enum.zip(padded_actual)
          |> Enum.map(&Outstanding.outstanding(elem(&1, 0), elem(&1, 1)))
      end

    _ ->
      expected
  end
end
