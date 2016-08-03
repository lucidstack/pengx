defmodule PengxTest do
  use ExUnit.Case, async: true
  doctest Pengx

  alias Pengx.Color

  @success 0

  test "generate simple png" do
    width = 200
    height =100
    background = %Color{r: 255, g: 127, b: 63}
    pengx = %Pengx{width: 400, height: 200}
    {:ok, data} = Pengx.render(pengx)
    assert {_output_data, @success} = Pngcheck.pngcheck(data)
  end
end
