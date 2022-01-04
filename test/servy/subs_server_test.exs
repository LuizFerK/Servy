defmodule Servy.SubsServerTest do
  use ExUnit.Case, async: true

  alias Servy.SubsServer

  test "caches the 3 most recent subs and totals their amounts" do
    SubsServer.start()

    SubsServer.subscribe("larry", 10)
    SubsServer.subscribe("moe", 20)
    SubsServer.subscribe("curly", 30)
    SubsServer.subscribe("daisy", 40)
    SubsServer.subscribe("grace", 50)

    most_recent_subs = [{"grace", 50}, {"daisy", 40}, {"curly", 30}]

    assert SubsServer.recent_subs() == most_recent_subs

    assert SubsServer.total_sub() == 120
  end
end
