# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Chatter.Repo.insert!(%Chatter.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
Chatter.Repo.delete_all(Chatter.Accounts.User)

Chatter.Repo.insert!((Chatter.Accounts.User.changeset(%Chatter.Accounts.User{}, %{username: "Demo-User", email: "demo@aa.io", password: "password"})))