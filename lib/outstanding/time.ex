# SPDX-FileCopyrightText: 2025 outstanding contributors <https://github.com/diffo-dev/outstanding/graphs.contributors>
#
# SPDX-License-Identifier: MIT

use Outstand

defoutstanding expected :: Time, actual :: Any do
  if Outstand.type_of(actual) != Time do
    expected
  else
    case Time.compare(expected, actual) do
      :eq ->
        nil

      _ ->
        expected
    end
  end
end
