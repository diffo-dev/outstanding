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
end
