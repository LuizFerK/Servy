defmodule Servy.Handler do
  @moduledoc "Handle HTTP requests."

  alias Servy.{Conn, Parser, Plugins}

  @pages_path Path.expand("../../pages", __DIR__)

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
    %{conn | status: 200, resp_body: "Users, Items, Orders"}
  end

  defp route(%Conn{method: "GET", path: "/items"} = conn) do
    %{conn | status: 200, resp_body: "Item 1, Item 2, Item 3"}
  end

  defp route(%Conn{method: "GET", path: "/items/" <> id} = conn) do
    %{conn | status: 200, resp_body: "Item #{id}"}
  end

  defp route(%Conn{method: "POST", path: "/items", params: params} = conn) do
    IO.inspect(conn)
    %{conn | status: 201, resp_body: "Create a #{params["type"]} item named #{params["name"]}!"}
  end

  defp route(%Conn{method: "DELETE", path: "/items/" <> _id} = conn) do
    %{conn | status: 403, resp_body: "Deleting an item is forbidden!"}
  end

  defp route(%Conn{method: "GET", path: "/orders/" <> id} = conn) do
    %{conn | status: 200, resp_body: "Order #{id}"}
  end

  defp route(%Conn{method: "GET", path: "/about"} = conn) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conn)
  end

  defp route(%Conn{method: "GET", path: path} = conn) do
    %{conn | status: 404, resp_body: "No #{path} here!"}
  end

  defp handle_file({:ok, content}, %Conn{} = conn) do
    %{conn | status: 200, resp_body: content}
  end

  defp handle_file({:error, :enoent}, %Conn{} = conn) do
    %{conn | status: 404, resp_body: "File not found!"}
  end

  defp handle_file({:error, reason}, %Conn{} = conn) do
    %{conn | status: 500, resp_body: "File error: #{reason}"}
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

response = Servy.Handler.call(request)

IO.puts(response)

request = """
GET /all HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.call(request)

IO.puts(response)

request = """
GET /items HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.call(request)

IO.puts(response)

request = """
GET /items/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.call(request)

IO.puts(response)

request = """
GET /items?id=1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.call(request)

IO.puts(response)

request = """
DELETE /items/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.call(request)

IO.puts(response)

request = """
GET /orders?id=1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.call(request)

IO.puts(response)

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.call(request)

IO.puts(response)

request = """
GET /invalid HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.call(request)

IO.puts(response)

request = """
POST /items HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Item 4&type=red
"""

response = Servy.Handler.call(request)

IO.puts(response)
