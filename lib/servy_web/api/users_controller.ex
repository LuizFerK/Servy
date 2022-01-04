defmodule ServyWeb.Api.UsersController do
  alias ServyWeb.Conn
  alias Servy.Users.Server

  def index(%Conn{} = conn) do
    users = Server.get_users()

    conn = Conn.put_resp_content_type(conn, "application/json")

    %{conn | status: 200, resp_body: Poison.encode!(users)}
  end
end
