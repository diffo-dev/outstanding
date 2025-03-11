use Outstand

defoutstanding expected :: Date, actual :: Any do
  if expected == nil or Outstand.type_of(actual) != Date do
    expected
  else
    case Date.compare(expected, actual) do
      :eq ->
        nil
      _ ->
        expected
    end
  end
end
