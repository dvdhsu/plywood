defmodule Plywood.AuthenticationController do
  use Plywood.Web, :controller

  alias Plywood.Authentication
  alias Plywood.User

  def login_or_create(conn, %{ "facebook_token" => facebook_token } = to_merge) do
    case Facebook.me("email,name", facebook_token) do
      {_, %{ "error" => error }} ->
        json(conn, %{error: error})
      { _, facebook_user } ->
        case Repo.get_by(User, facebook_id: facebook_user["id"]) do
          nil ->
            user_params =
            facebook_user
            |> Dict.put("auth_tokens", [])
            |> Dict.merge(to_merge)
            |> Dict.delete("id")
            Plywood.UserController.create(conn, user_params)
          user ->
            Plywood.UserController.show_with_new_token(conn, user)
        end
    end
  end

  def logout(conn, _params) do
    json conn, %{id: 123}
  end
end
