defmodule Servy.Handler do
  require Logger

  def call(conn) do
    conn
    |> parse()
    |> IO.inspect()
    |> rewrite_path()
    |> route()
    |> track()
    |> format_response()
  end

  defp parse(conn) do
    [method, path, _] =
      conn
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, resp_body: "", status: nil}
  end

  defp rewrite_path(%{path: "/wildlife"} = conn) do
    %{conn | path: "/wildthings"}
  end

  defp rewrite_path(%{path: path} = conn) do
    ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    |> Regex.named_captures(path)
    |> rewrite_path_captures(conn)
  end

  defp rewrite_path_captures(%{"thing" => thing, "id" => id}, conn) do
    %{conn | path: "/#{thing}/#{id}"}
  end

  defp rewrite_path_captures(nil, conn), do: conn

  defp route(%{method: "GET", path: "/wildthings"} = conn) do
    %{conn | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  defp route(%{method: "GET", path: "/bears"} = conn) do
    %{conn | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  defp route(%{method: "GET", path: "/bears/" <> id} = conn) do
    %{conn | status: 200, resp_body: "Bear #{id}"}
  end

  defp route(%{method: "GET", path: "/tigers/" <> id} = conn) do
    %{conn | status: 200, resp_body: "Tiger #{id}"}
  end

  defp route(%{method: "DELETE", path: "/bears/" <> _id} = conn) do
    %{conn | status: 403, resp_body: "Deleting a bear is forbidden!"}
  end

  defp route(%{method: "GET", path: "/about"} = conn) do
    Path.expand("../../pages", __DIR__)
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conn)
  end

  defp route(%{method: "GET", path: path} = conn) do
    %{conn | status: 404, resp_body: "No #{path} here!"}
  end

  defp handle_file({:ok, content}, conn) do
    %{conn | status: 200, resp_body: content}
  end

  defp handle_file({:error, :enoent}, conn) do
    %{conn | status: 404, resp_body: "File not found!"}
  end

  defp handle_file({:error, reason}, conn) do
    %{conn | status: 500, resp_body: "File error: #{reason}"}
  end

  defp track(%{status: 404, path: path} = conn) do
    Logger.warn("Warning: #{path} is on the loose!")
    conn
  end

  defp track(conn), do: conn

  defp format_response(conn) do
    """
    HTTP/1.1 #{conn.status} #{status_reason(conn.status)}
    Content-Type: text/html
    Content-Length: #{byte_size(conn.resp_body)}

    #{conn.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
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
