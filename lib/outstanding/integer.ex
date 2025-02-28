use Outstand

defoutstanding expected :: Integer, actual :: Any do
  case Outstand.type_of(actual) do
    Integer ->
      case actual do
        ^expected -> nil
        _ -> expected
      end
    Float ->
      if (expected == actual) do
        nil
      else
        expected
      end
    Range ->
      if (expected in actual) do
        nil
      else
        expected
      end
    _ ->
      expected
  end
end
