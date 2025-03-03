use Outstand

defoutstanding expected :: List, actual :: Any do
  case Outstand.type_of(actual) do
    List ->
      if (expected != [] and Keyword.keyword?(expected)) do
        # keyword lists are treated like maps, in that extra elements are tolerated and outstanding is called on 'matching' elements
        Keyword.keys(expected)
        |> Enum.filter(fn key ->
          (key not in Keyword.keys(actual) and key == :no_value) or
            Outstanding.outstanding(expected[key], actual[key]) != nil
        end)
        |> Enum.into([], &{&1, Outstanding.outstanding(expected[&1], actual[&1])})
        |> Outstand.suppress()
      else
        if Enum.count(expected) == Enum.count(actual) do
          {outstanding, _} =
            Enum.zip(expected, actual)
            |> Enum.filter(&Outstanding.outstanding(elem(&1, 0), elem(&1, 1)))
            |> Enum.unzip()
          Outstand.suppress(outstanding)
        else
          expected
        end
      end
    _ ->
      expected
  end
end
