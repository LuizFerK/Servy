defmodule Servy.ApplicationTest do
  use ExUnit.Case, async: true

  alias Servy.Application, as: ServyApp

  test "accepts a request on a socket and sends back a response" do
    spawn(ServyApp, :start, [4000])

    parent = self()

    max_concurrent_requests = 5

    for _ <- 1..max_concurrent_requests do
      spawn(fn ->
        {:ok, response} = HTTPoison.get("http://localhost:4000/")

        send(parent, {:ok, response})
      end)
    end

    for _ <- 1..max_concurrent_requests do
      receive do
        {:ok, response} ->
          assert response.status_code == 200
          assert response.body == "Users, Items, Orders"
      end
    end
  end
end
