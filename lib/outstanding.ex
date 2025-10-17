# SPDX-FileCopyrightText: 2025 outstanding contributors <https://github.com/diffo-dev/outstanding/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defprotocol Outstanding do
  @moduledoc """
  Protocol for comparing expected and actual, highlighting outstanding expectations unmet by actual
  """
  @fallback_to_any false
  @type t :: Outstanding.t()
  @type result :: nil | Outstanding.t()

  @doc """
  Outstanding of expected realised by actual, returns nil or outstanding
  """
  @spec outstanding(t, any()) :: result
  def outstanding(expected, actual)

  @doc """
  Is anything outstanding?
  """
  @spec outstanding?(t, any()) :: boolean()
  def outstanding?(expected, actual)

  defmacro __deriving__(module, options) do
    quote do
      defimpl Outstanding, for: unquote(module) do
        import Outstand, only: [map_to_struct: 2, outstanding?: 1]

        def outstanding(expected, actual) do
          case {expected, actual} do
            {_, ^expected} ->
              nil

            {%name{}, %name{}} ->
              expected
              |> Map.from_struct()
              |> Map.drop(Keyword.get(unquote(options), :except, []))
              |> Outstanding.outstanding(Map.from_struct(actual))
              |> Outstand.map_to_struct(name)

            {%name{}, _} ->
              expected
              |> Map.from_struct()
              |> Map.drop(Keyword.get(unquote(options), :except, []))
              |> Outstand.map_to_struct(name)
          end
        end

        def outstanding?(expected, actual) do
          Outstand.outstanding?(outstanding(expected, actual))
        end
      end
    end
  end
end
