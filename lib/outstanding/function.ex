use Outstand

defoutstanding expected :: Function, actual :: Any do
  # arity/1 expected function
  expected.(actual)
end
