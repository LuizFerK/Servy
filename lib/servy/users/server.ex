defmodule Servy.Users.Server do
  use GenServer

  alias Servy.Users.GetFromApi

  @name :user_server

  defmodule State do
    defstruct refresh_interval: 60, users: []
  end

  # Client
  def start_link(interval) do
    IO.puts("Starting the User server with #{interval} min refresh...")
    GenServer.start_link(__MODULE__, %State{}, name: @name)
  end

  def get_users do
    GenServer.call(@name, :get_users)
  end

  # Server callbacks
  def init(state) do
    users = get_users_from_api()
    schedule_refresh(state.refresh_interval)

    {:ok, %State{users: users}}
  end

  def handle_info(:refresh, state) do
    users = get_users_from_api()
    schedule_refresh(state.refresh_interval)

    {:noreply, %State{users: users}}
  end

  def handle_call(:get_users, _, state) do
    {:reply, state.users, state}
  end

  defp get_users_from_api do
    1..3
    |> Enum.map(&to_string/1)
    |> Enum.map(&Task.async(GetFromApi, :call, [&1]))
    |> Enum.map(&Task.await/1)
  end

  defp schedule_refresh(interval) do
    Process.send_after(self(), :refresh, interval)
  end
end
