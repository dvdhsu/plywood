defmodule Plywood.UserView do
  use Plywood.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Plywood.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Plywood.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      facebook_id: user.facebook_id,
      facebook_token: user.facebook_token,
      auth_tokens: user.auth_tokens}
  end
end
