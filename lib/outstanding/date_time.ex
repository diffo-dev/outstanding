# SPDX-FileCopyrightText: 2025 outstanding contributors <https://github.com/diffo-dev/outstanding/graphs.contributors>
#
# SPDX-License-Identifier: MIT

use Outstand

defoutstanding expected :: DateTime, actual :: Any do
  if Outstand.type_of(actual) != DateTime do
    expected
  else
    case DateTime.compare(expected, actual) do
      :eq ->
        nil

      _ ->
        expected
    end
  end
end
