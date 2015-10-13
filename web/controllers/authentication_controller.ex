defmodule Plywood.AuthenticationController do
  use Plywood.Web, :controller

  alias Plywood.Authentication
  alias Plywood.User

  def login_or_create(conn, %{ "facebook_token" => facebook_token }) do
    case Facebook.me("email,name", facebook_token) do
      {_, %{ "error" => error }} ->
        conn
          |> put_status(:unauthorized)
          |> json(%{error: error})
      { _, facebook_user } ->
        case Repo.get_by(User, facebook_id: facebook_user["id"]) do
          nil ->
            user_params = facebook_user
              |> Dict.put("auth_tokens", [User.new_token])
              |> Dict.put("facebook_id", facebook_user["id"])
              |> Dict.put("facebook_token", facebook_token)
              |> Dict.delete("id")
            create_user(conn, user_params)
          user ->
            auth_tokens = [User.new_token | user.auth_tokens]
            user = User.changeset(user, %{ auth_tokens: auth_tokens, facebook_token: facebook_token })

            case Repo.update user do
              {:ok, user} ->
                conn
                |> render(Plywood.UserView, "user_with_token.json", %{user: user, auth_token: hd auth_tokens})
              {:error, changeset} ->
                conn
                |> put_status(:unprocessable_entity)
                |> render(Plywood.ChangesetView, "error.json", changeset: changeset)
            end
        end
    end
  end

  def logout(conn, _params) do
    json conn, %{id: 123}
  end

  defp create_user(conn, user_params) do
    changeset = User.changeset(%User{}, user_params)
    auth_token = hd user_params["auth_tokens"]

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
          |> put_status(:created)
          |> render(Plywood.UserView, "user_with_token.json", %{user: user, auth_token: auth_token})
      {:error, changeset} ->
        conn
          |> put_status(:unprocessable_entity)
          |> render(Plywood.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
