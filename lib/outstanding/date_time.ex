use Outstand

defoutstanding expected :: DateTime, actual :: Any do
  if expected == nil or Outstand.type_of(actual) != DateTime do
    expected
  else
    case DateTime.compare(expected, actual) do
      :eq ->
        nil
      _ ->
        expected
    end
  end
end
