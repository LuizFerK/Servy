defmodule Servy.Items.GetAll do
  alias Servy.Item

  def call do
    [
      %Item{id: 1, name: "Item 1", color: "red", in_stock: true},
      %Item{id: 2, name: "Item 2", color: "yellow", in_stock: true},
      %Item{id: 3, name: "Item 3", color: "green", in_stock: true},
      %Item{id: 4, name: "Item 4", color: "black", in_stock: true},
      %Item{id: 5, name: "Item 5", color: "white"},
      %Item{id: 6, name: "Item 6", color: "pink"},
      %Item{id: 7, name: "Item 7", color: "brown", in_stock: true},
      %Item{id: 8, name: "Item 8", color: "gray", in_stock: true},
      %Item{id: 9, name: "Item 9", color: "purple", in_stock: true},
      %Item{id: 10, name: "Item 10", color: "blue", in_stock: true}
    ]
  end
end
