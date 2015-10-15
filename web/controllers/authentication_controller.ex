defmodule Melamine.AuthenticationController do
  use Melamine.Web, :controller

  alias Melamine.Authentication
  alias Melamine.User

  def login_or_create(conn, %{ "facebook_token" => facebook_token } = params) do
    inspect params
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
              |> Dict.put("last_location", params_location(params))
              |> Dict.delete("id")
            create_user(conn, user_params)
          user ->
            auth_tokens = [User.new_token | user.auth_tokens]
            user = User.changeset(user, %{ auth_tokens: auth_tokens, facebook_token: facebook_token, last_location: params_location(params) })
            case Repo.update user do
              {:ok, user} ->
                conn
                |> render(Melamine.UserView, "user_with_token.json", %{user: user, auth_token: hd auth_tokens})
              {:error, changeset} ->
                conn
                |> put_status(:unprocessable_entity)
                |> render(Melamine.ChangesetView, "error.json", changeset: changeset)
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
          |> render(Melamine.UserView, "user_with_token.json", %{user: user, auth_token: auth_token})
      {:error, changeset} ->
        conn
          |> put_status(:unprocessable_entity)
          |> render(Melamine.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp params_location(params) do
    if params["location"] && String.length(params["location"]) > 0 do
      Geo.WKT.decode(params["location"])
    else
      nil
    end
  end
end
