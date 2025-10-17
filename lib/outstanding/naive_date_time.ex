# SPDX-FileCopyrightText: 2025 outstanding contributors <https://github.com/diffo-dev/outstanding/graphs.contributors>
#
# SPDX-License-Identifier: MIT

use Outstand

defoutstanding expected :: NaiveDateTime, actual :: Any do
  if Outstand.type_of(actual) != NaiveDateTime do
    expected
  else
    case NaiveDateTime.compare(expected, actual) do
      :eq ->
        nil

      _ ->
        expected
    end
  end
end
