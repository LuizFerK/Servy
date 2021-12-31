defmodule ServyWeb.Router do
  @moduledoc "Handle HTTP requests."

  alias ServyWeb.{Conn, Parser, Plugins}

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
    HTTP/1.1 #{Conn.full_status(conn)}
    Content-Type: text/html
    Content-Length: #{byte_size(conn.resp_body)}

    #{conn.resp_body}
    """
  end
end

request = """
GET / HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = ServyWeb.Router.call(request)

IO.puts(response)

request = """
GET /all HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = ServyWeb.Router.call(request)

IO.puts(response)

request = """
GET /items HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = ServyWeb.Router.call(request)

IO.puts(response)

request = """
GET /items/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = ServyWeb.Router.call(request)

IO.puts(response)

request = """
GET /items?id=1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = ServyWeb.Router.call(request)

IO.puts(response)

request = """
DELETE /items/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = ServyWeb.Router.call(request)

IO.puts(response)

request = """
GET /orders?id=1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = ServyWeb.Router.call(request)

IO.puts(response)

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = ServyWeb.Router.call(request)

IO.puts(response)

request = """
GET /invalid HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = ServyWeb.Router.call(request)

IO.puts(response)

request = """
POST /items HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Item 4&color=red
"""

response = ServyWeb.Router.call(request)

IO.puts(response)
