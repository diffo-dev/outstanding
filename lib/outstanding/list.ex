use Outstand

defoutstanding expected :: List, actual :: List do
  if Enum.count(expected) == Enum.count(actual) do
    {outstanding, _} =
      Enum.zip(expected, actual)
      |> Enum.filter(&Outstand.outstanding(elem(&1, 0), elem(&1, 1)))
      |> Enum.unzip()
    Outstand.suppress(outstanding)
  else
    expected
  end
end
