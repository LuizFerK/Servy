defmodule ServyWeb.ItemsController do
  alias Servy.Item
  alias Servy.Items.{Create, Get, GetAll}
  alias ServyWeb.{Conn, ItemView}

  def index(%Conn{} = conn) do
    items = GetAll.call()

    %{conn | status: 200, resp_body: ItemView.index(items)}
  end

  def show(%Conn{} = conn, %{"id" => id}) do
    item = Get.call(id)

    %{conn | status: 200, resp_body: ItemView.show(item)}
  end

  def create(%Conn{} = conn, %{"name" => name, "color" => color}) do
    %Item{name: name, color: color} = Create.call(name, color)

    %{conn | status: 201, resp_body: "Created a #{color} item named #{name}!"}
  end

  def delete(%Conn{} = conn) do
    %{conn | status: 403, resp_body: "Deleting an item is forbidden!"}
  end
end
