use Outstand

defoutstanding expected :: Float, actual :: Float do
  case actual do
    ^expected -> nil
    _ -> expected
  end
end

# allow an float to be resolved by an equivalent integer
defoutstanding expected :: Float, actual :: Integer do
  case actual do
    ^expected -> nil
    _ -> expected
  end
end
