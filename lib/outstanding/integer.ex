use Outstand

defoutstanding expected :: Integer, actual :: Integer do
  case actual do
    ^expected -> nil
    _ -> expected
  end
end
