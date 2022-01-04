defmodule Servy.Application do
  use GenServer

  def start do
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_link()

    {:ok, server_pid}
  end

  def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts("ServyApp exited (#{inspect(reason)})")
    server_pid = start_link()

    {:noreply, server_pid}
  end

  defp start_link do
    server_pid = spawn_link(Servy.Endpoint, :start, [4000])
    Process.register(server_pid, :http_server)

    server_pid
  end
end
