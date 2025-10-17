# SPDX-FileCopyrightText: 2025 outstanding contributors <https://github.com/diffo-dev/outstanding/graphs.contributors>
#
# SPDX-License-Identifier: MIT

use Outstand

defoutstanding expected :: Regex, actual :: Any do
  case Regex.match?(expected, String.Chars.to_string(actual)) do
    true -> nil
    false -> expected
  end
end
