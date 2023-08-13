defmodule Xenakis.Union do
  defstruct [:elements]

  def new(elements) when is_list(elements) do
    %__MODULE__{elements: elements}
  end

  def add(%__MODULE__{elements: elements}, new_element) do
    new([new_element | elements])
  end

  def generate(%__MODULE__{elements: elements}) do
    elements
    |> Enum.map(& &1.__struct__.generate(&1))
    |> Enum.concat()
    |> Enum.sort()
    |> Enum.dedup()
  end
end
