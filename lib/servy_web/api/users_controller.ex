defmodule ServyWeb.Api.UsersController do
  alias Servy.User
  alias Servy.Users.GetFromApi
  alias ServyWeb.Conn

  def index(%Conn{} = conn) do
    caller = self()

    spawn(fn -> send(caller, {:result, GetFromApi.call("1")}) end)
    spawn(fn -> send(caller, {:result, GetFromApi.call("2")}) end)
    spawn(fn -> send(caller, {:result, GetFromApi.call("3")}) end)

    user1 =
      receive do
        {:result, {:ok, %User{} = user}} -> user
      end

    user2 =
      receive do
        {:result, {:ok, %User{} = user}} -> user
      end

    user3 =
      receive do
        {:result, {:ok, %User{} = user}} -> user
      end

    users = [user1, user2, user3]

    conn = Conn.put_resp_content_type(conn, "application/json")

    %{conn | status: 200, resp_body: Poison.encode!(users)}
  end
end
