defmodule Puls8.AccountsTest do
  use ExUnit.Case, async: true
  alias Puls8.Accounts.User, as: SUT

  describe "User.add_membership_changeset/2" do
    test "returns a changeset" do
      user = %SUT{}

      changeset = SUT.membership_changeset(user, [%{team_id: "id", roles: [:owner]}])
      assert changeset.valid?
    end

    test "returns a invalid changeset when invalid param is passed" do
      user = %SUT{}

      changeset = SUT.membership_changeset(user, [%{}])

      assert Puls8.DataCase.errors_on(changeset) == %{
               memberships: [%{roles: ["can't be blank"], team_id: ["can't be blank"]}]
             }
    end
  end
end
