use Outstand

defoutstanding expected :: Boolean, actual :: Any do
  case actual do
    ^expected -> nil
    _ -> expected
  end
end
