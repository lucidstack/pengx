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

    unless keep_pngs? do
      Temp.track!
    end

    {:ok, file_path} = Temp.open "test_png.png", &IO.binwrite(&1, data)
    if keep_pngs? do
      IO.puts "png=#{file_path}"
    end
    %Result{out: output, status: status} = Porcelain.exec("pngcheck", [file_path])

    {output, status}
  end

  defp keep_pngs? do
    System.get_env("KEEP_PNGS") != nil
  end

end
