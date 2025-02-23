use Outstand

defoutstanding expected :: MapSet, actual :: MapSet do
  # difference filters on non-equal, not nil outstanding
  ms_difference = MapSet.difference(expected, actual)
  expected
  |> Enum.filter(&MapSet.member?(ms_difference, &1))
  |> MapSet.new()
  |> Outstand.suppress()
end
