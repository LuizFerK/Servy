defmodule ServyWeb.IndexController do
  alias ServyWeb.Conn

  def index(%Conn{} = conn) do
    %{conn | status: 200, resp_body: "Users, Items, Orders"}
  end
end
