defmodule ServyWeb.Api.ItemsController do
  alias Servy.Items.GetAll
  alias ServyWeb.Conn

  def index(%Conn{} = conn) do
    items =
      GetAll.call()
      |> Poison.encode!()

    %{conn | status: 200, resp_content_type: "application/json", resp_body: items}
  end
end
