defmodule Servy.Items.Create do
  alias Servy.Item

  def call(name, color) do
    Item.build(name, color)
  end
end
