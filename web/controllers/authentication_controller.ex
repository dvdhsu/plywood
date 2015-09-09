defmodule Plywood.AuthenticationController do
  use Plywood.Web, :controller

  alias Plywood.Authentication
  alias Plywood.User

  def login_or_create(conn, %{ "facebook_token" => facebook_token } = to_merge) do
    { _, facebook_user } = Facebook.me "email,name", facebook_token
    user_params =
      facebook_user
      |> Dict.put("auth_tokens", [User.new_token])
      |> Dict.merge(to_merge)
      |> Dict.delete("id")

    # TODO: only create is implemented; should implement login as well
    create_user(conn, user_params)
  end

  def logout(conn, _params) do
    json conn, %{id: 123}
  end

  defp create_user(conn, user_params) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render(Plywood.UserView, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Plywood.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
