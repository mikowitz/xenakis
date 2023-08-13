defmodule Xenakis.Union do
  defstruct [:elements]

  import Xenakis.Helpers

  def new(elements) when is_list(elements) do
    %__MODULE__{elements: elements}
  end

  def generate(%__MODULE__{elements: elements}) do
    elements
    |> Enum.map(& &1.__struct__.generate(&1))
    |> reduce_map_set(MapSet.new(), &MapSet.union/2)
  end
end
