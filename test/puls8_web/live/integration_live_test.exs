defmodule Puls8Web.IntegrationLiveTest do
  use Puls8Web.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Puls8.AccountsFixtures

  defp create_team(_context) do
    team = team_fixture()
    %{team: team}
  end

  defp create_user(_context) do
    user = user_fixture()
    %{user: user}
  end

  defp add_member(%{user: user, team: team}) do
    {:ok, user} = add_member_fixture(user, team)
    %{user: user}
  end

  defp login_user(%{conn: conn, user: user}) do
    %{conn: log_in_user(conn, user)}
  end

  describe "Index" do
    setup [:create_team, :create_user, :add_member, :login_user]

    test "redirects to  integration page after it's created", %{
      conn: conn,
      team: team
    } do
      {:ok, view, _html} = live(conn, ~p"/teams/#{team}/integrations/new")

      view
      |> form("#add-integration", %{integration: %{name: "My Int", type: :grafana}})
      |> render_submit()

      {path, _flash} = assert_redirect(view)
      assert path == ~p"/teams/#{team}/integrations"
    end
  end
end
