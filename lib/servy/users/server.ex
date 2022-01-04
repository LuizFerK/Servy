defmodule Servy.Users.Server do
  use GenServer

  alias Servy.Users.GetFromApi

  @name :user_server
  @refresh_interval :timer.minutes(60)

  # Client
  def start do
    GenServer.start(__MODULE__, [], name: @name)
  end

  def get_users do
    GenServer.call(@name, :get_users)
  end

  # Server callbacks
  def init(_state) do
    state = get_users_from_api()
    schedule_refresh()

    {:ok, state}
  end

  def handle_info(:refresh, _state) do
    state = get_users_from_api()
    schedule_refresh()

    {:noreply, state}
  end

  def handle_call(:get_users, _, state) do
    {:reply, state, state}
  end

  defp get_users_from_api do
    1..3
    |> Enum.map(&to_string/1)
    |> Enum.map(&Task.async(GetFromApi, :call, [&1]))
    |> Enum.map(&Task.await/1)
  end

  defp schedule_refresh do
    Process.send_after(self(), :refresh, @refresh_interval)
  end
end
