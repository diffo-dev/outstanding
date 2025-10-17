# SPDX-FileCopyrightText: 2025 outstanding contributors <https://github.com/diffo-dev/outstanding/graphs.contributors>
#
# SPDX-License-Identifier: MIT

use Outstand

defoutstanding expected :: Date, actual :: Any do
  if Outstand.type_of(actual) != Date do
    expected
  else
    case Date.compare(expected, actual) do
      :eq ->
        nil

      _ ->
        expected
    end
  end
end
