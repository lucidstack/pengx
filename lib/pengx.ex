defmodule Pengx do
  alias Pengx.Color, as: Color
  alias Pengx.ColorType, as: ColorType
  alias Pengx.Data, as: Data
  alias Pengx.Palette, as: Palette
  alias Pengx.Scanline, as: Scanline

  defstruct \
    width: 0,
    height: 0,
    bit_depth: 1,
    color_type: ColorType.greyscale,
    compression_method: 0, # only ever 0
    filter_method: 0, # only ever 0
    interlace_method: 0, # can be 0 or 1
    palette: %Palette{},
    data: %Data{}

  def encode(pengx = %Pengx{}) do
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
    color_type: %ColorType{type: color_type},
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

  defp chunk_PLTE(%Pengx{ palette: %Palette{ colors: [] } }), do: <<>>

  defp chunk_PLTE(%Pengx{ palette: %Palette{ colors: colors } }) do
    data = colors |> Enum.map(fn(%Color{r: r, g: g, b: b}) ->
      <<r::8, g::8, b::8>>
    end)
    chunk("PLTE", data)
  end

  defp chunk_IDAT(%Pengx{ data: %Data{ scanlines: scanlines } }) do
    data = scanlines |> Enum.map(
      fn(%Scanline{ filter_type: ft, pixels: pixels}) ->
        <<ft::8, pixels::binary>>
      end
    )
    chunk("IDAT", :zlib.compress(data))
  end

  defp chunk_IEND(_pengx), do: chunk("IEND")

  defp chunk(chunk_type, chunk_data \\ <<>>) do
    <<
      byte_size(chunk_data) :: 32,
      chunk_type            :: binary,
      chunk_data            :: binary,
      Pengx.CRC.crc32(<<chunk_type :: binary, chunk_data::binary>>) :: 32
    >>
  end
end
