use Outstand

defoutstanding expected :: Duration, actual :: Any do
  if expected == nil or Outstand.type_of(actual) != Duration do
    expected
  else
    now = DateTime.utc_now()

    if DateTime.shift(now, expected) == DateTime.shift(now, actual) do
      nil
    else
      expected
    end
  end
end
