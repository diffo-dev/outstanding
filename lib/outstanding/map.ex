use Outstand

defoutstanding expected :: Map, actual :: Any do
  case Outstand.type_of(actual) do
    Map ->
      Map.keys(expected)
      |> Enum.filter(fn key ->
        not Map.has_key?(actual, key) or
          Outstanding.outstanding(expected[key], actual[key]) != nil
      end)
      |> Enum.into(%{}, &{&1, Outstanding.outstanding(expected[&1], actual[&1])})
      |> Outstand.suppress()

    _ ->
      expected
  end
end
