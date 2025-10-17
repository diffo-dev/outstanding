# SPDX-FileCopyrightText: 2025 outstanding contributors <https://github.com/diffo-dev/outstanding/graphs.contributors>
#
# SPDX-License-Identifier: MIT

use Outstand

defoutstanding expected :: Duration, actual :: Any do
  if Outstand.type_of(actual) != Duration do
    expected
  else
    now = DateTime.utc_now()

    if DateTime.shift(now, expected) == DateTime.shift(now, actual) do
      nil
    else
      expected
    end
  end
end
