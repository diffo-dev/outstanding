use Outstand

defoutstanding expected :: List, actual :: List do
  # uses map set, do determine difference,
  # ideally would call outstanding on each item in list, but needs to identify key
  # tuples would be good here, first item would be key
  ms_expected = MapSet.new(expected)
  ms_actual = MapSet.new(actual)
  ms_difference = MapSet.difference(ms_expected, ms_actual)
  expected
  |> Enum.filter(&MapSet.member?(ms_difference, &1))
  |> Outstand.suppress()
end
