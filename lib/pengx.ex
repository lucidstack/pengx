defmodule Pengx do
  defstruct \
    width: 0,
    height: 0,
    bit_depth: 1,
    color_type: Pengx.ColorType.greyscale,
    compression_method: 0, # only ever 0
    filter_method: 0, # only ever 0
    interlace_method: 0 # can be 0 or 1

  def render(pengx = %Pengx{}) do
    signature = <<0x89, ?P, ?N, ?G, 0x0D, 0x0A, 0x1A, 0x0A>>
    data = <<signature :: binary, chunks(pengx) :: binary>>
    {:ok, data}
  end

  defp chunks(pengx = %Pengx{}) do
    <<
      chunk_IHDR(pengx) ::binary,
      chunk_PLTE(pengx) ::binary,
      chunk_IDAT(pengx) ::binary,
      chunk_IEND(pengx) ::binary
    >>
  end

  defp chunk_IHDR(%Pengx{
    width: width,
    height: height,
    bit_depth: bit_depth,
    color_type: %Pengx.ColorType{type: color_type},
    compression_method: compression_method,
    filter_method: filter_method,
    interlace_method: interlace_method
  }) do
    data = <<
      width               :: 32,
      height              :: 32,
      bit_depth           :: 8,
      color_type          :: 8,
      compression_method  :: 8,
      filter_method       :: 8,
      interlace_method    :: 8
    >>
    chunk("IHDR", data)
  end

  defp chunk_PLTE(_pengx), do: <<>>
  defp chunk_IDAT(_pengx), do: <<>>
  defp chunk_IEND(_pengx), do: <<>>

  defp chunk(chunk_type, data) do
    chunk_data = <<>>
    <<
      byte_size(data) :: 32,
      chunk_type      :: 32,
      chunk_data      :: binary,
      crc(data)       :: 32
    >>
  end

  defp crc(_data) do
    123
  end
end
