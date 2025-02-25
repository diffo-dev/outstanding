use Outstand

defoutstanding expected :: Function, actual :: Atom do
  expected.(actual)
end

defoutstanding expected :: Function, actual :: BitString do
  expected.(actual)
end

defoutstanding expected :: Function, actual :: Boolean do
  expected.(actual)
end

defoutstanding expected :: Function, actual :: Float do
  expected.(actual)
end

defoutstanding expected :: Function, actual :: Integer do
  expected.(actual)
end

defoutstanding expected :: Function, actual :: List do
  expected.(actual)
end

defoutstanding expected :: Function, actual :: Map do
  expected.(actual)
end

defoutstanding expected :: Function, actual :: Range do
  expected.(actual)
end

defoutstanding expected :: Function, actual :: Tuple do
  expected.(actual)
end
