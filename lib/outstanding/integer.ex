use Outstand

defoutstanding expected :: Integer, actual :: Integer do
  case actual do
    ^expected -> nil
    _ -> expected
  end
end

# allow an integer to be resolved by an equivalent float
defoutstanding expected :: Integer, actual :: Float do
  if (expected == actual) do
    nil
  else
    expected
  end
end

# allow an integer to be resolved by a bounding range
defoutstanding expected :: Integer, actual :: Range do
  if (expected in actual) do
    nil
  else
    expected
  end
end
