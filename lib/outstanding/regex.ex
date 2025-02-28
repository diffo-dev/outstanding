use Outstand

defoutstanding expected :: Regex, actual :: Any do
  case Regex.match?(expected, actual) do
    true -> nil
    false -> expected
  end
end
