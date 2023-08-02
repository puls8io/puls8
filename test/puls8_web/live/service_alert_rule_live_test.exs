defmodule Puls8Web.ServiceAlertRuleLiveTest do
  use Puls8Web.ConnCase, async: true
  import Phoenix.LiveViewTest
  import Puls8.MonitoringFixtures

  @valid_param %{
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
      _rule = alert_rule_fixture(Map.put(@valid_param, :service, service))

      {:ok, view, _html} = live(conn, ~p"/teams/#{team}/services/#{service}/alert-rules")

      assert has_element?(view, "[data-role=alert-rule]", "prometheus")
      assert has_element?(view, "[data-role=alert-rule data-role=label]", "LiveViewTest=ABCD")
    end
  end

  def create_service(%{team: team}) do
    service = service_fixture(team: team)
    %{service: service}
  end
end
