defmodule Puls8Web.TeamLiveTest do
  use Puls8Web.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Puls8.AccountsFixtures

  @create_attrs %{name: "some new name", slug: "some-new-slug"}
  @invalid_attrs %{name: nil, slug: nil}

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

    test "lists only teams which current_user is member of", %{conn: conn, user: user} do
      others_team = team_fixture(%{name: "others team", slug: "others-team"})
      my_team01 = team_fixture(%{name: "my team 01", slug: "my-team-01"})
      my_team02 = team_fixture(%{name: "my team 02", slug: "my-team-02"})

      add_member_fixture(user, my_team01)
      add_member_fixture(user, my_team02)

      {:ok, _index_live, html} = live(conn, ~p"/teams")

      assert html =~ "Listing Teams"
      refute html =~ others_team.name
      assert html =~ my_team01.name
      assert html =~ my_team02.name
    end

    test "redirects to first team if there is only one team", %{
      conn: conn,
      team: team,
      user: user
    } do
      add_member_fixture(user, team)
      {_, {:live_redirect, %{to: "/teams/some-slug"}}} = live(conn, ~p"/teams")
    end

    test "saves new team for the current_user", %{conn: conn, user: user} do
      {:ok, index_live, _html} =
        conn
        |> live(~p"/teams")

      assert index_live |> element("a", "New Team") |> render_click() =~
               "New Team"

      assert_patch(index_live, ~p"/teams/new")

      assert index_live
             |> form("#team-form", team: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#team-form", team: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/teams")

      html = render(index_live)
      assert html =~ "Team created successfully"
      assert html =~ "some new name"

      user = Puls8.Repo.reload!(user)
      assert [_team] = user.memberships
    end

    test "deletes team in listing", %{conn: conn, team: team, user: user} do
      my_other_team = team_fixture(slug: "my-other-team")
      add_member_fixture(user, team)
      add_member_fixture(user, my_other_team)
      {:ok, index_live, _html} = live(conn, ~p"/teams")

      assert index_live |> element("#teams-#{team.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#teams-#{team.id}")
    end
  end

  describe "Show" do
    setup [:create_team, :create_user, :login_user]

    test "displays team", %{conn: conn, team: team} do
      {:ok, _show_live, html} = live(conn, ~p"/teams/#{team}")

      assert html =~ "Show Team"
      assert html =~ team.name
    end
  end
end
