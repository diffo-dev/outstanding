use Outstand

defoutstanding expected :: List, actual :: Any do
  case Outstand.type_of(actual) do
    List ->
      if Enum.count(expected) == Enum.count(actual) do
        {outstanding, _} =
          Enum.zip(expected, actual)
          |> Enum.filter(&Outstanding.outstanding(elem(&1, 0), elem(&1, 1)))
          |> Enum.unzip()
        Outstand.suppress(outstanding)
      else
        expected
      end
    _ ->
      expected
  end
end
