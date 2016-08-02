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
    Application.put_env(:porcelain, :goon_warn_if_missing, false)
    Application.ensure_started(:porcelain)

    proc = %Proc{pid: pid} = Porcelain.spawn_shell(
      "pngcheck",
      in: :receive,
      out: {:send, self()}
    )

   Proc.send_input(proc, data)
   Proc.send_input(proc, "\n")

   output_data = receive do
     {^pid, :data, :out, output_data} -> output_data
   after
     5000 -> raise "no output received from pngcheck within 5 seconds"
   end

   status = receive do
     {^pid, :result, %Result{status: status}} -> status
   after
     5000 -> raise "no status received from pngcheck within 5 seconds"
   end

   {output_data, status}
  end
end
