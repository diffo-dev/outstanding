use Outstand

defoutstanding expected :: Regex, actual :: Any do
  case Regex.match?(expected, String.Chars.to_string(actual)) do
    true -> nil
    false -> expected
  end
end
