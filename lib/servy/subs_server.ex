defmodule Servy.SubsServer do
  use GenServer

  @name :sub_server

  defmodule State do
    defstruct cache_size: 3, subs: []
  end

  # Client
  def start, do: GenServer.start(__MODULE__, %State{}, name: @name)

  def subscribe(name, amount) do
    GenServer.call(@name, {:subscribe, name, amount})
  end

  def recent_subs do
    GenServer.call(@name, :recent_subs)
  end

  def total_sub do
    GenServer.call(@name, :total_sub)
  end

  def clear do
    GenServer.cast(@name, :clear)
  end

  def set_cache_size(size) do
    GenServer.cast(@name, {:set_cache_size, size})
  end

  # Server callbacks
  def init(state) do
    cached_subs = fetch_recent_subs_from_service()

    {:ok, %{state | subs: cached_subs}}
  end

  def handle_call(:total_sub, _, state) do
    total = Enum.map(state.subs, &elem(&1, 1)) |> Enum.sum()

    {:reply, total, state}
  end

  def handle_call(:recent_subs, _, state), do: {:reply, state.subs, state}

  def handle_call({:subscribe, name, amount}, _, state) do
    {:ok, id} = send_sub_to_service(name, amount)
    cached_subs = [{name, amount} | Enum.take(state.subs, state.cache_size - 1)]

    {:reply, id, %{state | subs: cached_subs}}
  end

  def handle_cast(:clear, state), do: {:noreply, %{state | subs: []}}

  def handle_cast({:set_cache_size, size}, state) do
    {:noreply, %{state | cache_size: size}}
  end

  def handle_info(message, state) do
    IO.puts("Unhandling message #{inspect(message)}")
    {:noreply, state}
  end

  defp send_sub_to_service(_, _) do
    # simulation
    {:ok, "sub-#{:rand.uniform(1000)}"}
  end

  defp fetch_recent_subs_from_service do
    [{"wilma", 15}, {"fred", 25}]
  end
end
