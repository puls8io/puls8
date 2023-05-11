defmodule Puls8Web.TeamLiveTest do
  use Puls8Web.ConnCase

  import Phoenix.LiveViewTest
  import Puls8.AccountsFixtures

  @create_attrs %{name: "some new name", slug: "some-new-slug"}
  @update_attrs %{name: "some updated name", slug: "some-updated-slug"}
  @invalid_attrs %{name: nil, slug: nil}

  defp create_team(_) do
    team = team_fixture()
    %{team: team}
  end

  describe "Index" do
    setup [:create_team]

    test "lists all teams", %{conn: conn, team: team} do
      {:ok, _index_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/teams")

      assert html =~ "Listing Teams"
      assert html =~ team.name
    end

    test "saves new team", %{conn: conn} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
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
    end

    test "updates team in listing", %{conn: conn, team: team} do
      {:ok, index_live, _html} = live(conn, ~p"/teams")

      assert index_live |> element("#teams-#{team.id} a", "Edit") |> render_click() =~
               "Edit Team"

      assert_patch(index_live, ~p"/teams/#{team}/edit")

      assert index_live
             |> form("#team-form", team: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#team-form", team: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/teams")

      html = render(index_live)
      assert html =~ "Team updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes team in listing", %{conn: conn, team: team} do
      {:ok, index_live, _html} = live(conn, ~p"/teams")

      assert index_live |> element("#teams-#{team.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#teams-#{team.id}")
    end
  end

  describe "Show" do
    setup [:create_team]

    test "displays team", %{conn: conn, team: team} do
      {:ok, _show_live, html} = live(conn, ~p"/teams/#{team}")

      assert html =~ "Show Team"
      assert html =~ team.name
    end

    test "updates team within modal", %{conn: conn, team: team} do
      {:ok, show_live, _html} = live(conn, ~p"/teams/#{team}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Team"

      assert_patch(show_live, ~p"/teams/#{team}/show/edit")

      assert show_live
             |> form("#team-form", team: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#team-form", team: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/teams/#{team}")

      html = render(show_live)
      assert html =~ "Team updated successfully"
      assert html =~ "some updated name"
    end
  end
end
