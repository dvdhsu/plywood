defmodule Plywood.AuthenticationControllerTest do
  use Plywood.ConnCase

  alias Plywood.User

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    facebook_user = %{
      token: Application.get_env(:plywood, :facebook_test_token),
      email: Application.get_env(:plywood, :facebook_test_email),
    }
    conn = post conn, "/api/auth/login", %{ facebook_token: facebook_user[:token] }
    {:ok, conn: conn, facebook_user: facebook_user}
  end

  test "creates a user", %{conn: conn, facebook_user: facebook_user} do
    assert json_response(conn, 201)["data"]["email"] == facebook_user[:email]
  end

  test "logs in a user", %{conn: conn, facebook_user: facebook_user} do
    conn = post conn, "/api/auth/login", %{ facebook_token: facebook_user[:token] }
    assert json_response(conn, 200)["data"]["email"] == facebook_user[:email]
  end
end
