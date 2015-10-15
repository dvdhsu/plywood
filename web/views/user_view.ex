defmodule Melamine.UserView do
  use Melamine.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Melamine.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Melamine.UserView, "user.json")}
  end

  def render("user_with_token.json", %{user: user, auth_token: auth_token}) do
    %{data: (render_one(user, Melamine.UserView, "user.json")
             |> Dict.put("auth_token", auth_token))}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      facebook_id: user.facebook_id}
  end
end
