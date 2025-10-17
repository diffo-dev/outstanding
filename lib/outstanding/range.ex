# SPDX-FileCopyrightText: 2025 outstanding contributors <https://github.com/diffo-dev/outstanding/graphs.contributors>
#
# SPDX-License-Identifier: MIT

use Outstand

defoutstanding expected :: Range, actual :: Any do
  case Outstand.type_of(actual) do
    Range ->
      case actual do
        ^expected -> nil
        _ -> expected
      end

    Integer ->
      if actual in expected do
        nil
      else
        expected
      end

    _ ->
      expected
  end
end
