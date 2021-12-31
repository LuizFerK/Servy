defmodule ServyWeb.Router do
  @moduledoc "Handle HTTP requests."

  alias ServyWeb.{Api, Conn, Parser, Plugins}

  alias ServyWeb.{
    AboutController,
    ItemsController,
    OrdersController,
    IndexController
  }

  @doc "Transforms the request into a response."
  def call(request) do
    request
    |> Parser.call()
    |> Plugins.rewrite_path()
    |> route()
    |> Plugins.track()
    |> format_response()
  end

  defp route(%Conn{method: "GET", path: "/"} = conn) do
    IndexController.index(conn)
  end

  defp route(%Conn{method: "GET", path: "/items"} = conn) do
    ItemsController.index(conn)
  end

  defp route(%Conn{method: "GET", path: "/api/items"} = conn) do
    Api.ItemsController.index(conn)
  end

  defp route(%Conn{method: "GET", path: "/items/" <> id} = conn) do
    params = Map.put(conn.params, "id", id)
    ItemsController.show(conn, params)
  end

  defp route(%Conn{method: "POST", path: "/items", params: params} = conn) do
    ItemsController.create(conn, params)
  end

  defp route(%Conn{method: "DELETE", path: "/items/" <> _id} = conn) do
    ItemsController.delete(conn)
  end

  defp route(%Conn{method: "GET", path: "/orders/" <> id} = conn) do
    params = Map.put(conn.params, "id", id)
    OrdersController.show(conn, params)
  end

  defp route(%Conn{method: "GET", path: "/about"} = conn) do
    AboutController.index(conn)
  end

  defp route(%Conn{method: "GET", path: path} = conn) do
    %{conn | status: 404, resp_body: "No #{path} here!"}
  end

  defp format_response(%Conn{} = conn) do
    """
    HTTP/1.1 #{Conn.full_status(conn)}\r
    Content-Type: #{conn.resp_content_type}\r
    Content-Length: #{byte_size(conn.resp_body)}\r
    \r
    #{conn.resp_body}
    """
  end
end
