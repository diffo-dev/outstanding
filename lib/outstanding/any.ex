use Outstand

defoutstanding expected :: Any, actual :: Any do
  case {expected, actual} do
    {nil, _} ->
      nil
    {expected, expected} ->
      nil
    {%name{}, %name{}} ->
      expected
      |> Map.from_struct()
      |> Outstand.outstanding(Map.from_struct(actual))
    {_, _} ->
      # not an exact match so default to outstanding
      expected
  end
end
