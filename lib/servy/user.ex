defmodule Servy.User do
  defstruct id: nil, name: "", email: "", phone: ""

  def build(id, name, email, phone) do
    %__MODULE__{
      id: id,
      name: name,
      email: email,
      phone: phone
    }
  end
end
