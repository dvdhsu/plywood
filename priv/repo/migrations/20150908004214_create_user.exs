defmodule Melamine.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :facebook_id, :text
      add :facebook_token, :text
      add :auth_tokens, {:array, :string}
      add :last_location, :geometry

      timestamps
    end

    create index(:users, [:email], unique: true)
    create index(:users, [:facebook_id], unique: true)
  end
end
