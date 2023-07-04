defmodule Puls8Web.Live.ServicesLiveTest do
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

  defp login_user(%{conn: conn, user: user}) do
    %{conn: log_in_user(conn, user)}
  end

  describe "Index" do
    setup [:create_team, :create_user, :login_user]

    test "redirects to service page after service is created", %{
      conn: conn,
      user: user,
      team: team
    } do
      add_member_fixture(user, team)
      {:ok, view, _html} = live(conn, ~p"/teams/#{team}/services/new")

      view
      |> form("#add-service", %{service: %{name: "My Important Service"}})
      |> render_submit()

      {path, _flash} = assert_redirect(view)
      assert path == ~p"/teams/some-slug/services/1"
    end
  end
end
