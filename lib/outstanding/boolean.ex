use Outstand

defoutstanding expected :: Boolean, actual :: Any do
  if is_boolean(actual) and expected == actual do
    nil
  else
    expected
  end
end
