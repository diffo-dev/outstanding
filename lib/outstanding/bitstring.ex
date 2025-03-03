use Outstand

defoutstanding expected :: BitString, actual :: Any do
  if is_bitstring(actual) and expected == actual do
    nil
  else
    expected
  end
end
