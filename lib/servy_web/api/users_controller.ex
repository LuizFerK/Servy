defmodule ServyWeb.Api.UsersController do
  alias Servy.Users.GetFromApi
  alias ServyWeb.Conn

  def index(%Conn{} = conn) do
    users =
      1..3
      |> Enum.map(&to_string/1)
      |> Enum.map(&Task.async(GetFromApi, :call, [&1]))
      |> Enum.map(&Task.await/1)

    conn = Conn.put_resp_content_type(conn, "application/json")

    %{conn | status: 200, resp_body: Poison.encode!(users)}
  end
end
