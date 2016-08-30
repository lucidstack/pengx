defmodule Pengx.ColorType do
  alias Pengx.ColorType

  defstruct type: nil, name: nil, allowed_bit_depths: nil, palette: nil

  def greyscale do
    %ColorType{
      type: 0,
      name: "greyscale",
      allowed_bit_depths: [1, 2, 4, 8, 16],
      palette: :prohibited
    }
  end

  def truecolor do
    %ColorType{
      type: 2,
      name: "truecolor",
      allowed_bit_depths: [8, 16],
      palette: :optional
    }
  end

  def indexed_color do
    %ColorType{
      type: 3,
      name: "indexed_color",
      allowed_bit_depths: [1, 2, 4, 8],
      palette: :mandatory
    }
  end

  def greyscale_with_alpha do
    %ColorType{
      type: 4,
      name: "greyscale_with_alpha",
      allowed_bit_depths: [8, 16],
      palette: :prohibited
    }
  end

  def truecolor_with_alpha do
    %ColorType{
      type: 6,
      name: "truecolor_with_alpha",
      allowed_bit_depths: [8, 16],
      palette: :optional
    }
  end
end
