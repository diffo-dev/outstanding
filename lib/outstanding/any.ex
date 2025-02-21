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
      expected #TODO something here, but must avoid recursive call to Any
      #|> Outstand.outstanding(actual)
  end
end
