# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Puls8.Repo.insert!(%Puls8.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Puls8.{Accounts, Repo, Monitoring}

{:ok, user} =
  Accounts.register_user(%{
    email: "demo@example.com",
    password: "123456qwerty"
  })

Accounts.User.confirm_changeset(user) |> Repo.update!()

{:ok, team} = Accounts.create_team(%{name: "Example Inc", slug: "example"})

Accounts.add_membership(user, team, [:owner])

{:ok, service} = Monitoring.create_service(team, %{name: "my service"})

{:ok, _} =
  Monitoring.create_alert_route(service, %{
    labels: [
      %{"key" => "job", "value" => "myapp"},
      %{"key" => "alertname", "value" => "www status"}
    ],
    type: :grafana
  })
