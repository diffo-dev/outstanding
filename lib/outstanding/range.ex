use Outstand

defoutstanding expected :: Range, actual :: Range do
  case actual do
    ^expected -> nil
    _ -> expected
  end
end

# allow an range to be resolved by an integer in it
defoutstanding expected :: Range, actual :: Integer do
  if (actual in expected) do
    nil
  else
    expected
  end
end
