defmodule Servy.GenericServer do
  def start(callback_module, initial_state, process_name) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state, callback_module])
    Process.register(pid, process_name)
    pid
  end

  def call(pid, message) do
    send(pid, {:call, self(), message})

    receive do
      {:response, response} -> response
    end
  end

  def cast(pid, message) do
    send(pid, {:cast, message})
  end

  def listen_loop(state, callback_module) do
    receive do
      {:call, pid, message} when is_pid(pid) ->
        {response, state} = callback_module.handle_call(message, state)
        send(pid, {:response, response})
        listen_loop(state, callback_module)

      {:cast, message} ->
        state = callback_module.handle_cast(message, state)
        listen_loop(state, callback_module)

      unexpected ->
        IO.puts("Unexpected messaged: #{inspect(unexpected)}")
        listen_loop(state, callback_module)
    end
  end
end

defmodule Servy.SubsServer do
  alias Servy.GenericServer

  @process_name :sub_server

  # Client
  def start, do: GenericServer.start(__MODULE__, [], @process_name)

  def subscribe(name, amount) do
    GenericServer.call(@process_name, {:subscribe, name, amount})
  end

  def recent_subs do
    GenericServer.call(@process_name, :recent_subs)
  end

  def total_sub do
    GenericServer.call(@process_name, :total_sub)
  end

  def clear do
    GenericServer.cast(@process_name, :clear)
  end

  # Server callbacks
  def handle_call(:total_sub, state) do
    total = Enum.map(state, &elem(&1, 1)) |> Enum.sum()

    {total, state}
  end

  def handle_call(:recent_subs, state), do: {state, state}

  def handle_call({:subscribe, name, amount}, state) do
    {:ok, id} = send_sub_to_service(name, amount)
    state = [{name, amount} | Enum.take(state, 2)]

    {id, state}
  end

  def handle_cast(:clear, _state), do: []

  def send_sub_to_service(_, _) do
    # simulation
    {:ok, "sub-#{:rand.uniform(1000)}"}
  end
end
