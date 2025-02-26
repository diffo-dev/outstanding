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

defoutstanding expected :: Function, actual :: Date do
  expected.(actual)
end

defoutstanding expected :: Function, actual :: DateTime do
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

defoutstanding expected :: Function, actual :: MapSet do
  expected.(actual)
end

defoutstanding expected :: Function, actual :: NaiveDateTime do
  expected.(actual)
end

defoutstanding expected :: Function, actual :: Range do
  expected.(actual)
end

defoutstanding expected :: Function, actual :: Time do
  expected.(actual)
end

defoutstanding expected :: Function, actual :: Tuple do
  expected.(actual)
end
