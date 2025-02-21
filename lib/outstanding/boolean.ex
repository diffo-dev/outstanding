use Outstand

defoutstanding expected :: Boolean, actual :: Boolean do
  case actual do
    ^expected -> nil
    _ -> expected
  end
end
