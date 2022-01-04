defmodule Servy.SubsServer do
  @process_name :sub_server

  # Client
  def start do
    IO.puts("Starting the subs server...")
    pid = spawn(__MODULE__, :listen_loop, [[]])

    Process.register(pid, @process_name)

    pid
  end

  def subscribe(name, amount) do
    send(@process_name, {self(), :subscribe, name, amount})

    receive do
      {:status, status} -> status
    end
  end

  def recent_subs do
    send(@process_name, {self(), :recent_subs})

    receive do
      {:state, subs} -> subs
    end
  end

  def total_sub do
    send(@process_name, {self(), :total_sub})

    receive do
      {:total, total} -> total
    end
  end

  # Server
  def listen_loop(state) do
    receive do
      {pid, :subscribe, name, amount} ->
        {:ok, id} = send_sub_to_service(name, amount)
        state = [{name, amount} | Enum.take(state, 2)]

        send(pid, {:status, id})

        listen_loop(state)

      {pid, :recent_subs} ->
        send(pid, {:state, state})

        listen_loop(state)

      {pid, :total_sub} ->
        total = Enum.map(state, &elem(&1, 1)) |> Enum.sum()
        send(pid, {:total, total})

        listen_loop(state)

      unexpected ->
        IO.puts("Unexpected messaged: #{inspect(unexpected)}")
        listen_loop(state)
    end
  end

  defp send_sub_to_service(_, _) do
    # simulation
    {:ok, "sub-#{:rand.uniform(1000)}"}
  end
end
