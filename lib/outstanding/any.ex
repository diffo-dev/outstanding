use Outstand

defoutstanding expected :: Any, actual :: Any do
  case {expected, actual} do
    {nil, nil} ->
      nil
    {_, ^expected} ->
      nil
    {%name{}, %name{}} ->
      expected
      |> Map.from_struct()
      |> Outstanding.outstanding(Map.from_struct(actual))
      |> Outstand.map_to_struct(name)
    {_, _} ->
      # not an exact match so default to outstanding
      expected
  end
end
