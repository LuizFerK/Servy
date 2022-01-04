defmodule Servy.ServicesSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Servy.SubsServer,
      Servy.FourOhFourCounter,
      {Servy.Users.Server, 60}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
