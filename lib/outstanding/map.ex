use Outstand

defoutstanding expected :: Map, actual :: Any do
  case actual do
    %_{} ->
      Outstand.outstanding_map(expected, Map.from_struct(actual))

    %{} ->
      Outstand.outstanding_map(expected, actual)

    _ ->
      expected
  end
end
