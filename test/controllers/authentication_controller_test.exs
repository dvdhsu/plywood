defmodule Plywood.AuthenticationControllerTest do
  use Plywood.ConnCase

  alias Plywood.User

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end
end
