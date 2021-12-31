defmodule Servy.Item do
  defstruct id: nil, name: "", color: "", in_stock: false

  def build(name, color) do
    %__MODULE__{
      id: 0,
      name: name,
      color: color,
      in_stock: true
    }
  end
end
