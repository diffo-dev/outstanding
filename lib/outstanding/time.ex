use Outstand

defoutstanding expected :: Time, actual :: Any do
  if expected == nil or Outstand.type_of(actual) != Time do
    expected
  else
    case Time.compare(expected, actual) do
      :eq ->
        nil

      _ ->
        expected
    end
  end
end
