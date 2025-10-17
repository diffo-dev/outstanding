# SPDX-FileCopyrightText: 2025 outstanding contributors <https://github.com/diffo-dev/outstanding/graphs.contributors>
#
# SPDX-License-Identifier: MIT

use Outstand

defoutstanding expected :: Atom, actual :: Any do
  # nil is an atom, so needs to be handled here
  case {expected, actual} do
    {nil, nil} -> nil
    {:no_value, nil} -> nil
    {_, ^expected} -> nil
    {_, _} -> expected
  end
end
