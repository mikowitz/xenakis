defmodule Xenakis.Intersection do
  defstruct [:elements]

  def new(elements) when is_list(elements) do
    %__MODULE__{elements: elements}
  end

  def generate(%{elements: elements}) do
    [first | rest] =
      elements
      |> Enum.map(& &1.__struct__.generate(&1))
      |> Enum.map(&Enum.into(&1, MapSet.new()))

    Enum.reduce(rest, first, &MapSet.intersection(&1, &2))
    |> MapSet.to_list()
    |> Enum.sort()
  end
end
