use Outstand

defoutstanding expected :: DateTime, actual :: Any do
  case {expected, actual} do
    {nil, nil} ->
      nil
    {_, ^expected} ->
      nil
    {_, _} ->
      expected
  end
end
