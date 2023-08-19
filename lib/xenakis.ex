defmodule Xenakis do
  alias Xenakis.Sieve, as: S
  alias Xenakis.Intersection, as: I
  alias Xenakis.Union, as: U

  def a &&& b do
    I.new([new_sieve_maybe(a), new_sieve_maybe(b)])
  end

  def a ||| b do
    U.new([new_sieve_maybe(a), new_sieve_maybe(b)])
  end

  defp new_sieve_maybe({a, b}), do: S.new(a, b)
  defp new_sieve_maybe(%S{} = sieve), do: sieve
  defp new_sieve_maybe(%I{} = x), do: x
  defp new_sieve_maybe(%U{} = x), do: x

  def generate(%struct{} = x) do
    struct.generate(x)
  end

  @doc """

    iex> Xenakis.major_scale(0)
    ...>   |> Xenakis.generate()
    ...>   |> Enum.take(7)
    [0, 2, 4, 5, 7, 9, 11]

  """
  def major_scale(n) do
    ({-3, rem(n + 2, 3)} &&& {4, rem(n, 4)}) |||
      ({-3, rem(n + 1, 3)} &&& {4, rem(n + 1, 4)}) |||
      ({3, rem(n + 2, 3)} &&& {4, rem(n + 2, 4)}) |||
      ({-3, rem(n, 3)} &&& {4, rem(n + 3, 4)})
  end
end
