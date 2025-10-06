use Outstand

defoutstanding expected :: Date, actual :: Any do
  if Outstand.type_of(actual) != Date do
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
