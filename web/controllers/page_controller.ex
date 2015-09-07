defmodule Plywood.PageController do
  use Plywood.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
