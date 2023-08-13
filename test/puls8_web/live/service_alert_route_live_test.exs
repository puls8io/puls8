defmodule Puls8Web.ServiceAlertRouteLiveTest do
  use Puls8Web.ConnCase, async: true
  import Phoenix.LiveViewTest
  import Puls8.MonitoringFixtures

  @valid_attrs %{
    type: :prometheus,
    labels: [%{key: "LiveViewTest", value: "ABCD"}]
  }

  describe "Index" do
    setup [:register_and_log_in_user, :create_service]

    test "list rules", %{
      conn: conn,
      team: team,
      service: service
    } do
      _rule = alert_rule_fixture(Map.put(@valid_attrs, :service, service))

      {:ok, view, _html} = live(conn, ~p"/teams/#{team}/services/#{service}/alert-routes")

      assert has_element?(view, "[data-role=alert-routes]", "prometheus")
      assert has_element?(view, "[data-role=alert-route data-role=label]", "LiveViewTest=ABCD")
    end

    test "saves new alert route", %{conn: conn, team: team, service: service} do
      valid_attrs = %{
        "labels" => %{"0" => %{"key" => "testcase", "value" => "AlertRouteTestABC"}},
        "labels_drop" => [""],
        "labels_sort" => ["0"],
        "type" => "grafana"
      }

      {:ok, index_live, _html} = live(conn, ~p"/teams/#{team}/services/#{service}/alert-routes")

      assert index_live |> element("[data-role=new-alert-route-link]") |> render_click()

      assert_patch(index_live, ~p"/teams/#{team}/services/#{service}/alert-routes/new")

      assert index_live
             |> form("[data-role=alert-route-form]", alert_route: valid_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/teams/#{team}/services/#{service}/alert-routes")

      assert has_element?(
               index_live,
               "[data-role=alert-routes data-role=label]",
               "AlertRouteTestABC"
             )
    end
  end

  def create_service(%{team: team}) do
    service = service_fixture(team: team)
    %{service: service}
  end
end
