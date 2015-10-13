defmodule Plywood.AuthenticationControllerTest do
  use Plywood.ConnCase

  alias Plywood.User

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    facebook_user = %{
      token: "CAAK56gVae7wBAJWibxdnihHkvIdR713HPb8MMpWaI7ZCRSWb45bmyhLK2nTJxVFlZAguR9gIDTzPLhmXLDvtKC8ZCjejDCRrn0ZBi1becSLq97SxR1fQpj6FZAyXwMaeUHYhl5NEpVRi8kaoKPyZAHZCHlUKSosMHp2xJeULMxZCDK1ZAXts45GpwOO1Lke1iPvl8mZCLeHKlBYLL4lWVWOZBeP",
      email: "hhacqxl_lausen_1444688968@tfbnw.net"
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
