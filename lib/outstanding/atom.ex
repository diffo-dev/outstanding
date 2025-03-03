use Outstand

defoutstanding expected :: Atom, actual :: Any do
  # nil is an atom, so needs to be handled here
  case {expected, actual} do
    {nil, nil} -> nil
    {:no_value, nil} -> nil
    {_, ^expected} -> nil
    {_, _} -> expected
  end
end
