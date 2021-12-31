defmodule ServyWeb.Api.ItemsController do
  alias Servy.Item
  alias Servy.Items.{Create, GetAll}
  alias ServyWeb.Conn

  def index(%Conn{} = conn) do
    items =
      GetAll.call()
      |> Poison.encode!()

    conn = Conn.put_resp_content_type(conn, "application/json")

    %{conn | status: 200, resp_body: items}
  end

  def create(%Conn{} = conn, %{"name" => name, "color" => color}) do
    %Item{name: name, color: color} = Create.call(name, color)

    %{conn | status: 201, resp_body: "Created a #{color} item named #{name}!"}
  end
end
