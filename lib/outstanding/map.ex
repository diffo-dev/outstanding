# SPDX-FileCopyrightText: 2025 outstanding contributors <https://github.com/diffo-dev/outstanding/graphs.contributors>
#
# SPDX-License-Identifier: MIT

use Outstand

defoutstanding expected :: Map, actual :: Any do
  case actual do
    %_{} ->
      Outstand.outstanding_map(expected, Map.from_struct(actual))

    %{} ->
      Outstand.outstanding_map(expected, actual)

    _ ->
      expected
  end
end
