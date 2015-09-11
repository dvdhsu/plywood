defmodule Plywood.User do
  use Plywood.Web, :model

  schema "users" do
    field :email, :string
    field :facebook_id, :string
    field :facebook_token, :string
    field :auth_tokens, {:array, :string}

    timestamps
  end

  @required_fields ~w(email facebook_id facebook_token auth_tokens)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  def add_token(model) do
    auth_tokens = model.auth_tokens
    if (length auth_tokens) > 50 do
      auth_tokens = tl auth_tokens
    end
    new_auth_token = new_token
    auth_tokens = auth_tokens ++ [new_auth_token];
    user_params = %{ auth_tokens: auth_tokens }

    %{changeset: changeset(model, user_params),
      new_auth_token: new_auth_token}
  end

  def new_token do
    :crypto.strong_rand_bytes(64) |> Base.encode16(case: :lower)
  end
end
