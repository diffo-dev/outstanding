use Outstand

defoutstanding expected :: BitString, actual :: Any do
  case actual do
    ^expected -> nil
    _ -> expected
  end
end
