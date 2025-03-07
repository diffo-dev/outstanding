use Outstand

defoutstanding expected :: Tuple, actual :: Any do
  if is_function(elem(expected, 0)) and tuple_size(expected) == 2 do
    # tuple contains an arity/2 expected function, where first element is function and second is term
    elem(expected, 0).(elem(expected, 1), actual)
  else
    # regular tuple
    case Outstand.type_of(actual) do
      Tuple ->
        if tuple_size(expected) == tuple_size(actual) do
          {outstanding, _} =
            Enum.zip(Tuple.to_list(expected), Tuple.to_list(actual))
            |> Enum.filter(&Outstanding.outstanding(elem(&1, 0), elem(&1, 1)))
            |> Enum.unzip()
          if (outstanding == []) do
            nil
          else
            expected
          end
        else
          expected
        end
      _ ->
        expected
    end
  end
end
