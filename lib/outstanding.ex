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

  @impl true
  defmacro __deriving__(module, _options) do
    quote do
      defimpl Outstanding, for: unquote(module) do
        import Outstand, only: [map_to_struct: 2, outstanding?: 1]
        def outstanding(expected, actual) do
          case {expected, actual} do
            {nil, nil} ->
              nil

            {_, ^expected} ->
              nil

            {%name{}, %name{}} ->
              expected
              |> Map.from_struct()
              |> Outstanding.outstanding(Map.from_struct(actual))
              |> Outstand.map_to_struct(name)

            {_, _} ->
              # not an exact match so default to outstanding
              expected
          end
        end
        def outstanding?(expected, actual) do
          Outstand.outstanding?(outstanding(expected, actual))
        end
      end
    end
  end
end
