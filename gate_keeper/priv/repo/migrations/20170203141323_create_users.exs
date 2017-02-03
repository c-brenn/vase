defmodule GateKeeper.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, primary_key: true
      add :encrypted_password, :string

      timestamps
    end
  end
end
