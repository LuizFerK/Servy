defmodule ServyWeb.Conn do
  defstruct method: "",
            path: "",
            params: %{},
            headers: %{},
            resp_headers: %{"Content-Type" => "text/html", "Content-Length" => 0},
            resp_body: "",
            status: nil

  def full_status(%__MODULE__{} = conn) do
    "#{conn.status} #{status_reason(conn.status)}"
  end

  def format_response_headers(conn) do
    for {key, value} <- conn.resp_headers do
      "#{key}: #{value}\r"
    end
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.join("\n")
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end

  def put_resp_content_type(conn, type) do
    headers = Map.put(conn.resp_headers, "Content-Type", type)
    %{conn | resp_headers: headers}
  end

  def put_content_length(conn) do
    headers = Map.put(conn.resp_headers, "Content-Length", byte_size(conn.resp_body))
    %{conn | resp_headers: headers}
  end
end
