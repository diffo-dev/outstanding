use Outstand

defoutstanding expected :: Function, actual :: Any do
  case expected.(actual) do
    true -> nil
    _ -> expected
  end
end
