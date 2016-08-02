defmodule Pengx do
  defstruct width: 0, height: 0, background: %Pengx.Color{}

  def new(width, height, background) do
    {:ok, %Pengx{width: width, height: height, background: background}}
  end

  def render(%Pengx{}) do
    {:ok, "foobar\n"}
  end
end
