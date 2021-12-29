defmodule Servy.Handler do
  def call(conn) do
    conn
    |> parse()
    |> route()
    |> format_response()
  end

  defp parse(conn) do
    [method, path, _] =
      conn
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, resp_body: ""}
  end

  defp route(conn) do
    %{conn | resp_body: "Bears, Lions, Tigers"}
  end

  defp format_response(conn) do
    """
    HTTP/1.1 200 OK
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
