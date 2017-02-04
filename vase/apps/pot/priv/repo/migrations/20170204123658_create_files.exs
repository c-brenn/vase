defmodule Pot.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :path, :string
      add :contents, :bytea
      timestamps
    end

    create unique_index(:files, [:path])
  end
end
