defmodule Pengx.CRC do
  use Bitwise

  @polynomial 0xedb88320

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
