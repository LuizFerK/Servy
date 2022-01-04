defmodule ServyWeb.SubsController do
  alias Servy.SubsServer

  def index(conn) do
    subs = SubsServer.recent_subs()

    %{conn | status: 200, resp_body: inspect(subs)}
  end

  def create(conn, %{"name" => name, "amount" => amount}) do
    SubsServer.subscribe(name, String.to_integer(amount))

    %{conn | status: 201, resp_body: "#{name} subscribed with the amount of #{amount}!"}
  end
end
