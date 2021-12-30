defmodule Servy.ItemsController do
  alias Servy.Conn
  alias Servy.Items.GetAll, as: GetAllItems
  alias Servy.Items.Get, as: GetItem

  def index(%Conn{} = conn) do
    items =
      GetAllItems.call()
      |> Enum.sort(fn i1, i2 -> i1.name <= i2.name end)
      |> Enum.map(fn item -> "<li>#{item.name} - #{item.color}</li>" end)
      |> Enum.join()

    %{conn | status: 200, resp_body: "<ul>#{items}</ul>"}
  end

  def show(%Conn{} = conn, %{"id" => id}) do
    item = GetItem.call(id)

    %{conn | status: 200, resp_body: "<h1>Item #{item.id}: #{item.name}</h1>"}
  end

  def create(%Conn{} = conn, %{"name" => name, "color" => color}) do
    %{conn | status: 201, resp_body: "Create a #{color} item named #{name}!"}
  end

  def delete(%Conn{} = conn) do
    %{conn | status: 403, resp_body: "Deleting an item is forbidden!"}
  end
end
