defmodule ServyWeb.Api.ItemsController do
  alias Servy.Items.GetAll
  alias ServyWeb.Conn

  def index(%Conn{} = conn) do
    items =
      GetAll.call()
      |> Poison.encode!()

    conn = Conn.put_resp_content_type(conn, "application/json")

    %{conn | status: 200, resp_body: items}
  end
end
