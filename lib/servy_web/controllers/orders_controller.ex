defmodule ServyWeb.OrdersController do
  alias ServyWeb.Conn

  def show(%Conn{} = conn, %{"id" => id}) do
    %{conn | status: 200, resp_body: "Order #{id}"}
  end
end
