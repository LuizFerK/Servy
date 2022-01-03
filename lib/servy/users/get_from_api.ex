defmodule Servy.Users.GetFromApi do
  alias Servy.User

  def call(id) do
    {:ok, user} =
      api_url(id)
      |> HTTPoison.get()
      |> handle_response

    user
  end

  defp api_url(id) do
    "https://jsonplaceholder.typicode.com/users/#{URI.encode(id)}"
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    %{"id" => id, "name" => name, "email" => email, "phone" => phone} =
      Poison.Parser.parse!(body, %{})

    {:ok, User.build(id, name, email, phone)}
  end

  defp handle_response({:ok, %{status_code: _status, body: body}}) do
    {:error, Poison.Parser.parse!(body, %{})["message"]}
  end

  defp handle_response({:error, %{reason: reason}}) do
    {:error, reason}
  end
end
