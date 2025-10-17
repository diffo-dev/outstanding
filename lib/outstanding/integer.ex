# SPDX-FileCopyrightText: 2025 outstanding contributors <https://github.com/diffo-dev/outstanding/graphs.contributors>
#
# SPDX-License-Identifier: MIT

use Outstand

defoutstanding expected :: Integer, actual :: Any do
  case Outstand.type_of(actual) do
    Integer ->
      case actual do
        ^expected -> nil
        _ -> expected
      end

    Float ->
      if expected == actual do
        nil
      else
        expected
      end

    Range ->
      if expected in actual do
        nil
      else
        expected
      end

    _ ->
      expected
  end
end
