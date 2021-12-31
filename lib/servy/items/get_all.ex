defmodule Servy.Items.GetAll do
  alias Servy.Item

  @json_path Path.expand("../../../priv/json", __DIR__)

  def call do
    @json_path
    |> Path.join("items.json")
    |> read_json
    |> Poison.decode!(as: %{"items" => [%Item{}]})
    |> Map.get("items")
  end

  defp read_json(source) do
    case File.read(source) do
      {:ok, contents} ->
        contents

      {:error, reason} ->
        IO.inspect("Error reading #{source}: #{reason}")
        "[]"
    end
  end
end
