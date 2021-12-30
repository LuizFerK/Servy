defmodule Servy.Parser do
  alias Servy.Conn

  def call(conn) do
    [method, path, _] =
      conn
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %Conn{method: method, path: path}
  end
end
