defmodule Xenakis.UnionTest do
  use ExUnit.Case

  alias Xenakis.{Sieve, Union}

  describe "new/2" do
    test "can take a list of sieves" do
      union =
        Union.new([
          Sieve.new(3, 2),
          Sieve.new(4, 1)
        ])

      assert length(union.elements) == 2
    end

    test "can take a union as an element" do
      union =
        Union.new([
          Sieve.new(3, 2),
          Union.new([
            Sieve.new(4, 1),
            Sieve.new(5, 0)
          ])
        ])

      assert length(union.elements) == 2
    end
  end

  describe "generate" do
    test "must explicitly evaluate the union" do
      union =
        Union.new([
          Sieve.new(3, 2),
          Union.new([
            Sieve.new(4, 1),
            Sieve.new(5, 0)
          ])
        ])

      assert Union.generate(union) |> Enum.take(10) ==
               [0, 1, 2, 5, 8, 9, 10, 11, 13, 14]
    end

    test "is commutative" do
      s1 = Sieve.new(3, 2)
      s2 = Sieve.new(4, 1)

      u1 = Union.new([s1, s2])
      u2 = Union.new([s2, s1])

      assert Union.generate(u1) == Union.generate(u2)
    end

    test "is associative" do
      s1 = Sieve.new(3, 2)
      s2 = Sieve.new(4, 1)
      s3 = Sieve.new(5, 0)

      u1 = Union.new([s1, Union.new([s2, s3])])
      u2 = Union.new([Union.new([s1, s2]), s3])

      assert Union.generate(u1) == Union.generate(u2)
    end

    test "works with a negated sieve" do
      union =
        Union.new([
          Sieve.new(4, 0),
          Sieve.new(-3, 2)
        ])

      assert Union.generate(union) |> Enum.take(10) == [0, 1, 3, 4, 6, 7, 8, 9, 10, 12]
    end
  end
end
