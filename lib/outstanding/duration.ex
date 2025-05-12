use Outstand

defoutstanding expected :: Duration, actual :: Any do
  if expected == nil or Outstand.type_of(actual) != Duration do
    expected
  else
    if to_timeout(expected) == to_timeout(actual) do
      nil
    else
      expected
    end
  end
end
