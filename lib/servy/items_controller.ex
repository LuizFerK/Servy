defmodule Servy.ItemsController do
  alias Servy.Conn
  alias Servy.Items.GetAll, as: GetAllItems
  alias Servy.Items.Get, as: GetItem

  @templates_path Path.expand("../../templates", __DIR__)

  defp render(conn, template, bindings) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{conn | status: 200, resp_body: content}
  end

  def index(%Conn{} = conn) do
    items =
      GetAllItems.call()
      |> Enum.sort(fn i1, i2 -> i1.name <= i2.name end)

    render(conn, "index.eex", items: items)
  end

  def show(%Conn{} = conn, %{"id" => id}) do
    item = GetItem.call(id)

    render(conn, "show.eex", item: item)
  end

  def create(%Conn{} = conn, %{"name" => name, "color" => color}) do
    %{conn | status: 201, resp_body: "Create a #{color} item named #{name}!"}
  end

  def delete(%Conn{} = conn) do
    %{conn | status: 403, resp_body: "Deleting an item is forbidden!"}
  end
end
