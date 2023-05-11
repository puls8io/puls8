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

    test "lists all teams", %{conn: conn, team: team} do
      _team1 = team_fixture(%{slug: "plug-2"})

      {:ok, _index_live, html} = live(conn, ~p"/teams")

      assert html =~ "Listing Teams"
      assert html =~ team.name
    end

    test "redirects to first team if there is only one team", %{
      conn: conn,
      team: team,
      user: user
    } do
      {:ok, _index_live, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/teams/some-slug")

      assert html =~ team.name
    end

    test "saves new team for the current_user", %{conn: conn, user: user} do
      _team1 = team_fixture(%{slug: "plug-2"})

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
      assert html =~ "some name"

      user = Puls8.Repo.reload!(user)
      assert [_team] = user.memberships
    end

    test "deletes team in listing", %{conn: conn, team: team} do
      _team1 = team_fixture(%{slug: "plug-2"})
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
