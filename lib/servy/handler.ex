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

  defp route(%Conn{method: "GET", path: "/wildthings"} = conn) do
    %{conn | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  defp route(%Conn{method: "GET", path: "/bears"} = conn) do
    %{conn | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  defp route(%Conn{method: "GET", path: "/bears/" <> id} = conn) do
    %{conn | status: 200, resp_body: "Bear #{id}"}
  end

  defp route(%Conn{method: "POST", path: "/bears", params: params} = conn) do
    IO.inspect(conn)
    %{conn | status: 201, resp_body: "Create a #{params["type"]} bear named #{params["name"]}!"}
  end

  defp route(%Conn{method: "GET", path: "/tigers/" <> id} = conn) do
    %{conn | status: 200, resp_body: "Tiger #{id}"}
  end

  defp route(%Conn{method: "DELETE", path: "/bears/" <> _id} = conn) do
    %{conn | status: 403, resp_body: "Deleting a bear is forbidden!"}
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
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.call(request)

IO.puts(response)

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.call(request)

IO.puts(response)

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.call(request)

IO.puts(response)

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.call(request)

IO.puts(response)

request = """
GET /bears?id=1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.call(request)

IO.puts(response)

request = """
GET /tigers?id=1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.call(request)

IO.puts(response)

request = """
DELETE /bears/1 HTTP/1.1
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
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.call(request)

IO.puts(response)

request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Baloo&type=Brown
"""

response = Servy.Handler.call(request)

IO.puts(response)
