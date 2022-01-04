defmodule Servy do
  use Application

  def start(_type, _args) do
    Servy.Supervisor.start_link()
  end
end
