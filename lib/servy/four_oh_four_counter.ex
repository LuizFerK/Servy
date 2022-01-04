defmodule Servy.FourOhFourCounter do
  alias Servy.GenericServer

  @process_name :four_oh_four_counter

  # Client
  def start do
    IO.puts("Starting the 404 counter server...")
    GenericServer.start(__MODULE__, %{}, @process_name)
  end

  def bump_count(path) do
    GenericServer.call(@process_name, {:bump_count, path})
  end

  def get_counts do
    GenericServer.call(@process_name, :get_counts)
  end

  def get_count(path) do
    GenericServer.call(@process_name, {:get_count, path})
  end

  def reset do
    GenericServer.cast(@process_name, :reset)
  end

  # Server callbacks
  def handle_call({:bump_count, path}, state) do
    state = Map.update(state, path, 1, &(&1 + 1))
    {:ok, state}
  end

  def handle_call(:get_counts, state) do
    {state, state}
  end

  def handle_call({:get_count, path}, state) do
    count = Map.get(state, path, 0)
    {count, state}
  end

  def handle_cast(:reset, _state) do
    %{}
  end
end
