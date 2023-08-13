defmodule Xenakis.SieveTest do
  use ExUnit.Case, async: true

  alias Xenakis.Sieve

  describe "new" do
    test "negation is handled correctly" do
      assert Sieve.new(-3, 2) == %Sieve{modulo: 3, init: 2, negation: true}
    end
  end

  describe "generate" do
    test "works with a simple sieve" do
      assert Sieve.new(4, 0) |> Sieve.generate(6) == [0, 4, 8, 12, 16, 20]
    end

    test "works with a negated sieve" do
      assert Sieve.new(3, 2) |> Sieve.negate() |> Sieve.generate(6) == [0, 1, 3, 4, 6, 7]
    end

    test "works with a sieve negated at init" do
      assert Sieve.new(-3, 2) |> Sieve.generate(6) == [0, 1, 3, 4, 6, 7]
    end
  end
end
