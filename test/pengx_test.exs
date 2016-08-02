defmodule PengxTest do
  use ExUnit.Case
  doctest Pengx

  alias Pengx.Color

  @success 0

  test "generate simple png" do
    width = 200
    height =100
    background = %Color{r: 255, g: 127, b: 63}
    {:ok, pengx} = Pengx.new(width, height, background)
    {:ok, data} = Pengx.render(pengx)
    assert {_output_data, @success} = Pngcheck.pngcheck(data)
  end
end
