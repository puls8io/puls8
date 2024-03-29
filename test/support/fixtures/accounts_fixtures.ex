defmodule Puls8.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Puls8.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Puls8.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: "some name",
        slug: "some-slug#{System.unique_integer()}"
      })
      |> Puls8.Accounts.create_team()

    team
  end

  def add_member_fixture(user, team, roles \\ []) do
    Puls8.Accounts.add_membership(user, team, roles)
  end
end
