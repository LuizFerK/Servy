defmodule ServyWeb.AboutController do
  alias ServyWeb.Conn

  @pages_path Path.expand("../../priv/pages", __DIR__)

  def index(%Conn{} = conn) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conn)
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
end
