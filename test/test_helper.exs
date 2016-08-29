ExUnit.start()

defmodule Pngcheck do
  alias Porcelain.Process, as: Proc
  alias Porcelain.Result

  def pngcheck_installed! do
    case System.cmd "which", ["pngcheck"] do
      {_path, 0} -> :ok
      {_no_path, _failure_status} -> raise "pngcheck not installed"
    end
  end

  def pngcheck(data) do
    pngcheck_installed!
    Application.ensure_started(:porcelain)

    Temp.track!
    {:ok, file_path} = Temp.open "test_png.png", &IO.binwrite(&1, data)
    %Result{out: output, status: status} = Porcelain.exec("pngcheck", [file_path])

    {output, status}
  end
end
