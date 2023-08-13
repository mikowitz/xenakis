defmodule Xenakis.Sieve do
  defstruct [:modulo, :init, negation: false]

  def new(modulo, init) when modulo < 0 do
    %__MODULE__{
      modulo: -modulo,
      init: init,
      negation: true
    }
  end

  def new(modulo, init) do
    %__MODULE__{
      modulo: modulo,
      init: init
    }
  end

  def negate(%__MODULE__{} = s) do
    %__MODULE__{s | negation: !s.negation}
  end

  def generate(%__MODULE__{modulo: m, init: i, negation: n} = s, take \\ 100) do
    case n do
      false -> Stream.iterate(i, &(&1 + m)) |> Enum.take(take)
      true -> generate_negation(s, take)
    end
  end

  defp generate_negation(%__MODULE__{} = sieve, take) do
    sieve
    |> invert()
    |> Xenakis.Union.new()
    |> Xenakis.Union.generate()
    |> Enum.take(take)
  end

  def invert(%__MODULE__{modulo: m, init: i, negation: true}) do
    for n <- 0..(m - 1), n != i do
      new(m, n)
    end
  end
end
