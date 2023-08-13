defmodule Xenakis.IntersectionTest do
  use ExUnit.Case

  alias Xenakis.{Intersection, Sieve}

  describe "new/1" do
    test "can take a list of sieves" do
      intersection =
        Intersection.new([
          Sieve.new(3, 2),
          Sieve.new(4, 1)
        ])

      assert length(intersection.elements) == 2
    end

    test "can take an intersection as an element" do
      intersection =
        Intersection.new([
          Sieve.new(3, 2),
          Intersection.new([
            Sieve.new(4, 1),
            Sieve.new(5, 0)
          ])
        ])

      assert length(intersection.elements) == 2
    end
  end

  describe "generate" do
    test "must explicitly evaluate the intersection" do
      intersection =
        Intersection.new([
          Sieve.new(3, 2),
          Intersection.new([
            Sieve.new(4, 1),
            Sieve.new(5, 0)
          ])
        ])

      assert Intersection.generate(intersection) |> Enum.take(5) == [5, 65, 125, 185, 245]
    end

    test "is commutative" do
      s1 = Sieve.new(4, 1)
      s2 = Sieve.new(5, 0)

      i1 = Intersection.new([s1, s2])
      i2 = Intersection.new([s2, s1])

      assert Intersection.generate(i1) == Intersection.generate(i2)
    end

    test "is associative" do
      s1 = Sieve.new(4, 1)
      s2 = Sieve.new(5, 0)
      s3 = Sieve.new(3, 2)

      i1 = Intersection.new([s1, Intersection.new([s2, s3])])
      i2 = Intersection.new([Intersection.new([s1, s2]), s3])

      assert Intersection.generate(i1) == Intersection.generate(i2)
    end

    test "works with negated sieves" do
      intersection =
        Intersection.new([
          Sieve.new(4, 0),
          Sieve.new(-3, 2)
        ])

      assert Intersection.generate(intersection) |> Enum.take(10) == [
               0,
               4,
               12,
               16,
               24,
               28,
               36,
               40,
               48,
               52
             ]
    end
  end
end
