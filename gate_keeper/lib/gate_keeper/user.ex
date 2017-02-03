defmodule GateKeeper.User do
  use Ecto.Schema
  alias Comeonin.Bcrypt
  require Logger

  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    timestamps
  end

  @required_fields [:username, :password]

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:username, on: GateKeeper.Repo, downcase: true)
    |> validate_length(:password, minimum: 1)
  end

  def encrypt_password(changeset) do
    hash = Bcrypt.hashpwsalt(changeset.params["password"])
    put_change(changeset, :encrypted_password, hash)
  end

  def authenticate(user, password) do
    Bcrypt.checkpw(password, user.encrypted_password)
  end
end
