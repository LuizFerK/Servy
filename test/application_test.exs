defmodule Servy.ApplicationTest do
  use ExUnit.Case, async: true

  alias Servy.Application, as: ServyApp

  test "accepts a request on a socket and sends back a response" do
    spawn(ServyApp, :start, [4000])

    urls = ["http://localhost:4000/", "http://localhost:4000/api/items"]

    urls
    |> Enum.map(&Task.async(fn -> HTTPoison.get(&1) end))
    |> Enum.map(&Task.await/1)
    |> Enum.map(&assert_successful_response/1)
  end

  defp assert_successful_response({:ok, response}) do
    assert response.status_code == 200
  end
end
