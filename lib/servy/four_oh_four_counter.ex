defmodule Servy.FourOhFourCounter do
  @process_name :four_oh_four_server

  # Client
  def start(initial_state \\ %{}) do
    IO.puts("Starting the 404 counter server...")
    pid = spawn(__MODULE__, :listen_loop, [initial_state])

    Process.register(pid, @process_name)

    pid
  end

  def bump_count(path) do
    send(@process_name, {self(), :bump_count, path})

    receive do
      {:status, status} -> status
    end
  end

  def get_count(path) do
    send(@process_name, {self(), :get_count, path})

    receive do
      {:count, count} -> count
    end
  end

  def get_counts do
    send(@process_name, {self(), :get_counts})

    receive do
      {:state, state} -> state
    end
  end

  # Server
  def listen_loop(state) do
    receive do
      {pid, :bump_count, path} ->
        state = Map.update(state, path, 1, &(&1 + 1))
        send(pid, {:status, "#{path} was called #{state[path]} times!"})

        listen_loop(state)

      {pid, :get_count, path} ->
        count = Map.get(state, path, 0)
        send(pid, {:count, count})

        listen_loop(state)

      {pid, :get_counts} ->
        send(pid, {:state, state})

        listen_loop(state)

      unexpected ->
        IO.puts("Unexpected messaged: #{inspect(unexpected)}")
        listen_loop(state)
    end
  end
end
