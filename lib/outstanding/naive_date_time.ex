use Outstand

defoutstanding expected :: NaiveDateTime, actual :: Any do
  if Outstand.type_of(actual) != NaiveDateTime do
    expected
  else
    case NaiveDateTime.compare(expected, actual) do
      :eq ->
        nil

      _ ->
        expected
    end
  end
end
