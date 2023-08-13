defmodule Xenakis do
  alias Xenakis.Sieve, as: S
  alias Xenakis.Intersection, as: I
  alias Xenakis.Union, as: U

  def generate(x) do
    x.__struct__.generate(x)
  end

  def major_scale(n) do
    U.new([
      I.new([
        S.new(-3, rem(n + 2, 3)),
        S.new(4, rem(n, 4))
      ]),
      I.new([
        S.new(-3, rem(n + 1, 3)),
        S.new(4, rem(n + 1, 4))
      ]),
      I.new([
        S.new(3, rem(n + 2, 3)),
        S.new(4, rem(n + 2, 4))
      ]),
      I.new([
        S.new(-3, rem(n, 3)),
        S.new(4, rem(n + 3, 4))
      ])
    ])
  end
end
