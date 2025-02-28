use Outstand

defoutstanding expected :: Map, actual :: Any do
  case Outstand.type_of(actual) do
    Map ->
      Map.keys(expected)
      |> Enum.filter(&(Outstanding.outstanding(expected[&1], actual[&1])))
      |> Enum.into(%{}, &{&1, Outstanding.outstanding(expected[&1], actual[&1])})
      |> Outstand.suppress()
    _ ->
      expected
    end
end
