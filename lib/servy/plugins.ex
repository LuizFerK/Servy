defmodule Servy.Plugins do
  require Logger

  alias Servy.Conn

  def rewrite_path(%Conn{path: "/wildlife"} = conn) do
    %Conn{conn | path: "/wildthings"}
  end

  def rewrite_path(%Conn{path: path} = conn) do
    ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    |> Regex.named_captures(path)
    |> rewrite_path_captures(conn)
  end

  defp rewrite_path_captures(%{"thing" => thing, "id" => id}, conn) do
    %Conn{conn | path: "/#{thing}/#{id}"}
  end

  defp rewrite_path_captures(nil, %Conn{} = conn), do: conn

  def track(%Conn{status: 404, path: path} = conn) do
    Logger.warn("Warning: #{path} is on the loose!")
    conn
  end

  def track(%Conn{} = conn), do: conn
end
