defmodule ServyWeb.RouterTest do
  use ExUnit.Case, async: true

  import ServyWeb.Router, only: [call: 1]

  test "GET /api/items" do
    request = """
    GET /api/items HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = call(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: application/json\r
    Content-Length: 572\r
    \r
    [{"name":"Item1","in_stock":true,"id":1,"color":"red"},
    {"name":"Item2","in_stock":true,"id":2,"color":"yellow"},
    {"name":"Item3","in_stock":true,"id":3,"color":"green"},
    {"name":"Item4","in_stock":true,"id":4,"color":"black"},
    {"name":"Item5","in_stock":false,"id":5,"color":"white"},
    {"name":"Item6","in_stock":false,"id":6,"color":"pink"},
    {"name":"Item7","in_stock":true,"id":7,"color":"brown"},
    {"name":"Item8","in_stock":true,"id":8,"color":"gray"},
    {"name":"Item9","in_stock":true,"id":9,"color":"purple"},
    {"name":"Item10","in_stock":true,"id":10,"color":"blue"}]
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /" do
    request = """
    GET / HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = call(request)

    assert response == """
           HTTP/1.1 200 OK\r
           Content-Type: text/html\r
           Content-Length: 20\r
           \r
           Users, Items, Orders
           """
  end

  test "GET /items" do
    request = """
    GET /items HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = call(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 347\r
    \r
    <h1>All the items!</h1>

    <ul>
      <li>Item 1 - red</li>
      <li>Item 2 - yellow</li>
      <li>Item 3 - green</li>
      <li>Item 4 - black</li>
      <li>Item 5 - white</li>
      <li>Item 6 - pink</li>
      <li>Item 7 - brown</li>
      <li>Item 8 - gray</li>
      <li>Item 9 - purple</li>
      <li>Item 10 - blue</li>
    </ul>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /invalid" do
    request = """
    GET /invalid HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = call(request)

    assert response == """
           HTTP/1.1 404 Not Found\r
           Content-Type: text/html\r
           Content-Length: 17\r
           \r
           No /invalid here!
           """
  end

  test "GET /items/1" do
    request = """
    GET /items/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = call(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 69\r
    \r
    <h1>Show item</h1>
    <p>
    Is Item 1 in stock? <strong>true</strong>
    </p>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /all" do
    request = """
    GET /all HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = call(request)

    assert response == """
           HTTP/1.1 200 OK\r
           Content-Type: text/html\r
           Content-Length: 20\r
           \r
           Users, Items, Orders
           """
  end

  test "GET /about" do
    request = """
    GET /about HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = call(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 329\r
    \r
    <h1>Clark's Wildthings Refuge</h1>

    <blockquote>
      When we contemplate the whole globe as one great dewdrop,
      striped and dotted with continents and islands, flying
      through space with other stars all singing and shining
      together as one, the whole universe appears as an infinite
      storm of beauty. -- John Muir
    </blockquote>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "POST /items" do
    request = """
    POST /items HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/x-www-form-urlencoded\r
    Content-Length: 21\r
    \r
    name=Item 1&color=red
    """

    response = call(request)

    assert response == """
           HTTP/1.1 201 Created\r
           Content-Type: text/html\r
           Content-Length: 32\r
           \r
           Created a red item named Item 1!
           """
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end
end
