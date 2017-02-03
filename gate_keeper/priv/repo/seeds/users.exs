alias GateKeeper.{User, Repo}

%User{}
|> User.changeset(%{username: "admin", password: "admin"})
|> User.encrypt_password()
|> Repo.insert!()
