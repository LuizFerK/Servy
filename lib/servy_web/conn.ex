defmodule ServyWeb.Conn do
  defstruct method: "",
            path: "",
            params: %{},
            headers: %{},
            resp_content_type: "text/html",
            resp_body: "",
            status: nil

  def full_status(%__MODULE__{} = conn) do
    "#{conn.status} #{status_reason(conn.status)}"
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
end
