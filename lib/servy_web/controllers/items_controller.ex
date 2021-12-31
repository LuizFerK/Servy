defmodule ServyWeb.ItemsController do
  alias ServyWeb.Conn
  alias Servy.Item
  alias Servy.Items.{Create, Get, GetAll}

  @templates_path Path.expand("../templates", __DIR__)

  defp render(%Conn{} = conn, template, bindings) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{conn | status: 200, resp_body: content}
  end

  def index(%Conn{} = conn) do
    items =
      GetAll.call()
      |> Enum.sort(fn i1, i2 -> i1.name <= i2.name end)

    render(conn, "index.eex", items: items)
  end

  def show(%Conn{} = conn, %{"id" => id}) do
    item = Get.call(id)

    render(conn, "show.eex", item: item)
  end

  def create(%Conn{} = conn, %{"name" => name, "color" => color}) do
    %Item{name: name, color: color} = Create.call(name, color)

    %{conn | status: 201, resp_body: "Create a #{color} item named #{name}!"}
  end

  def delete(%Conn{} = conn) do
    %{conn | status: 403, resp_body: "Deleting an item is forbidden!"}
  end
end
