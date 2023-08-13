defmodule Xenakis.Intersection do
  defstruct [:elements]

  alias Xenakis.{Sieve, Union}

  def new(elements) when is_list(elements) do
    %__MODULE__{elements: elements}
  end

  def generate(%__MODULE__{elements: elements}) do
    [first | rest] =
      elements
      |> Enum.map(& &1.__struct__.generate(&1))
      |> Enum.map(&Enum.into(&1, MapSet.new()))

    Enum.reduce(rest, first, &MapSet.intersection(&1, &2))
    |> MapSet.to_list()
    |> Enum.sort()
  end

  def reduce(%__MODULE__{elements: [first | rest]}) do
    Enum.reduce(rest, first, &reduce(&1, &2))
  end

  def reduce(%Sieve{negation: true} = s1, %Sieve{} = s2) do
    s1
    |> Sieve.invert()
    |> Enum.map(fn s -> new([s, s2]) end)
    |> Enum.map(&reduce/1)
    |> Union.new()
  end

  def reduce(%Sieve{} = s1, %Sieve{negation: true} = s2) do
    reduce(s2, s1)
  end

  def reduce(%Sieve{} = s1, %Sieve{} = s2) do
    %Sieve{modulo: m1, init: i1} = s1
    %Sieve{modulo: m2, init: i2} = s2
    d = Integer.gcd(m1, m2)
    c1 = m1 / d
    c2 = m2 / d
    m3 = d * c1 * c2

    {m3, i3} =
      case d == 1 do
        true ->
          case {c1 / 1, c2 / 1} do
            {1.0, 1.0} -> {m3, 0}
            {1.0, _} -> {m3, i2}
            {_, 1.0} -> {m3, i1}
            _ -> compare_m1_m2(c1, c2, i1, i2, m1, m2, m3)
          end

        false ->
          if i1 == i2 do
            {m3, i1}
          else
            avg = abs(i1 - i2) / d

            if round(avg) == avg do
              case {c1 / 1, c2 / 1} do
                {1.0, 1.0} -> {m3, i1}
                {1.0, _} -> tuple_with_mod(m3, i2, i1, 1, c2)
                {_, 1.0} -> tuple_with_mod(m3, i1, i2, 1, c1)
                _ -> compare_m1_m2(c1, c2, i1, i2, m1, m2, m3)
              end
            else
              {0, 0}
            end
          end
      end

    m3 = round(m3)
    i3 = round(i3)

    case {m3, i3} do
      {0, 0} -> Sieve.new(0, 0)
      {m3, i3} -> Sieve.new(m3, Integer.mod(i3, m3))
    end
  end

  defp compare_m1_m2(c1, c2, i1, i2, m1, m2, m3) do
    if m1 >= m2 do
      tuple_with_mod(m3, i1, i2, find_z(c1, c2, 0), c1)
    else
      tuple_with_mod(m3, i2, i1, find_z(c1, c2, 0), c2)
    end
  end

  defp tuple_with_mod(m3, a1, a2, z, c), do: {m3, mod(a1 + z * (a2 - a1) * c, m3)}

  defp mod(n, m), do: rem(round(n), round(m))

  defp find_z(mult, modulo, z) do
    if mod(mult * z, modulo) != 1 do
      find_z(mult, modulo, z + 1)
    else
      z
    end
  end
end
