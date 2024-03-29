defmodule Puls8Web.Live.ServicesLiveTest do
  use Puls8Web.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Puls8.MonitoringFixtures

  describe "Index" do
    setup [:register_and_log_in_user]

    test "redirects to service page after service is created", %{
      conn: conn,
      team: team
    } do
      {:ok, view, _html} = live(conn, ~p"/teams/#{team}/services/new")

      view
      |> form("#add-service", %{service: %{name: "My Important Service"}})
      |> render_submit()

      {path, _flash} = assert_redirect(view)
      assert path == ~p"/teams/#{team}/services/1"
    end
  end

  describe "Show" do
    setup [:register_and_log_in_user]

    test "renders show", %{conn: conn, team: team} do
      service = service_fixture(team: team, name: "Show my service")
      {:ok, view, _html} = live(conn, ~p"/teams/#{team}/services/#{service}")

      assert has_element?(view, "[data-role=service]", "Show my service")
    end

    test "renders 404 when service doesn't exist", %{conn: conn, team: team} do
      assert_raise Ecto.NoResultsError, fn ->
        {:ok, _view, _html} = live(conn, ~p"/teams/#{team}/services/38833")
      end
    end
  end
end
