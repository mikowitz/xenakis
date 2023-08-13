defmodule Xenakis.Helpers do
  def reduce_map_set(lists, initial_map_set, reduce_fn) do
    lists
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(initial_map_set, reduce_fn)
    |> MapSet.to_list()
    |> Enum.sort()
  end
end
