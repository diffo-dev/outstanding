# SPDX-FileCopyrightText: 2025 outstanding contributors <https://github.com/diffo-dev/outstanding/graphs.contributors>
#
# SPDX-License-Identifier: MIT

use Outstand

defoutstanding expected :: MapSet, actual :: Any do
  case Outstand.type_of(actual) do
    MapSet ->
      # difference filters on non-equal, not nil outstanding
      ms_difference = MapSet.difference(expected, actual)

      expected
      |> Enum.filter(&MapSet.member?(ms_difference, &1))
      |> MapSet.new()
      |> Outstand.suppress()

    _ ->
      expected
  end
end
