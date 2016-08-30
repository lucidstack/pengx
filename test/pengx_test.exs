defmodule PengxTest do
  use ExUnit.Case, async: true
  doctest Pengx

  alias Pengx.Color

  @success 0

  test "generate simple png" do
    width = 400
    height = 200
    pengx = %Pengx{
      width: width,
      height: height,
      bit_depth: 8,
      color_type: Pengx.ColorType.greyscale,
      data: %Pengx.Data{
        scanlines: Enum.map(1..height, fn(_h) ->
          %Pengx.Scanline{pixels: Enum.reduce(1..width, <<>>, fn(_w, acc) ->
            <<acc::binary, 123::8>>
          end)}
        end)
      }
    }
    {:ok, data} = Pengx.encode(pengx)
    assert {_output_data, @success} = Pngcheck.pngcheck(data)
  end
end
