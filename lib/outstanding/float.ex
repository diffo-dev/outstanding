use Outstand

defoutstanding expected :: Float, actual :: Any do
  case Outstand.type_of(actual) do
    Float ->
      case actual do
        ^expected -> nil
        _ -> expected
      end

    Integer ->
      if expected == actual do
        nil
      else
        expected
      end

    _ ->
      expected
  end
end
