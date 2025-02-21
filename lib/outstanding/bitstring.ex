use Outstand

defoutstanding expected :: BitString, actual :: BitString do
  case actual do
    ^expected -> nil
    _ -> expected
  end
end
