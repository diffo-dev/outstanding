defprotocol Outstanding do

  @moduledoc """
  Protocol for comparing expected and actual, highlighting outstanding expectations unmet by actual
  """
  @fallback_to_any true
  @type t :: Outstanding.t()
  @type result :: nil | Outstanding.t()

  @doc """
  Accepts struct with fields :expected and :actual, returns nil or outstanding
  """
  @spec outstanding(t) :: result
  def outstanding(expected_and_actual)
end
