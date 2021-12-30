defmodule Servy.Items.Get do
  alias Servy.Items.GetAll, as: GetAllItems

  def call(id) when is_integer(id) do
    Enum.find(GetAllItems.call(), fn item -> item.id == id end)
  end

  def call(id) when is_binary(id) do
    id |> String.to_integer() |> call()
  end
end
