defmodule Pengx.CRC do
  # translated from C code at https://www.w3.org/TR/PNG/#D-CRCAppendix into pure
  # Elixir

  use Bitwise

  # x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 +
  # x^4 + x^2 + x + 1
  @polynomial 0xedb88320

  # build lookup table as an optimisation by generating a function clause for
  # each possible byte value (0-255)
  Enum.each(0..255, fn(n) ->
    c = Enum.reduce(0..7, n, fn(_k, c) ->
      if (c &&& 1) == 1 do
        @polynomial ^^^ (c >>> 1)
      else
        c >>> 1
      end
    end)

    defp crc32_table(unquote(n)), do: unquote(c)
  end)

  def crc32(data) do
    do_crc32(0xffffffff, data)
  end

  defp do_crc32(crc, <<h::8, t::binary>>) do
    next_crc = crc32_table((crc ^^^ h) &&& 0xff) ^^^ (crc >>> 8)
    do_crc32(next_crc, t)
  end

  defp do_crc32(crc, <<>>) do
    crc ^^^ 0xffffffff
  end
end
