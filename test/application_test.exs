defmodule Servy.ApplicationTest do
  use ExUnit.Case

  alias Servy.Application, as: ServyApp
  alias Servy.HttpClient

  test "accepts a request on a socket and sends back a response" do
    spawn(ServyApp, :start, [4000])

    request = """
    GET / HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = HttpClient.send_request(request)

    assert response == """
           HTTP/1.1 200 OK\r
           Content-Type: text/html\r
           Content-Length: 20\r
           \r
           Users, Items, Orders
           """
  end
end
