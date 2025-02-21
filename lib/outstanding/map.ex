use Outstand

defoutstanding expected :: Map, actual :: Map do
  Map.keys(expected)
  |> Enum.filter(&(Outstand.outstanding(expected[&1], actual[&1])))
  |> Enum.into(%{}, &{&1, Outstand.outstanding(expected[&1], actual[&1])})
  |> Outstand.suppress()
end
