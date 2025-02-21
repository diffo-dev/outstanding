use Outstand

defoutstanding expected :: Atom, actual :: Atom do
  # nil is an atom, so needs to be handled here
  # nil expectation always met
  case {expected, actual} do
    {nil, _} -> nil
    {expected, expected} -> nil
    {_, _} -> expected
  end
end
