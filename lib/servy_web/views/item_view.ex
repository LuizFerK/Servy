defmodule ServyWeb.ItemView do
  require EEx

  alias ServyWeb.Conn

  @templates_path Path.expand("../templates", __DIR__)

  def render(%Conn{} = conn, template, bindings \\ []) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{conn | status: 200, resp_body: content}
  end

  EEx.function_from_file(:def, :index, Path.join(@templates_path, "index.eex"), [:items])

  EEx.function_from_file(:def, :show, Path.join(@templates_path, "show.eex"), [:item])
end
