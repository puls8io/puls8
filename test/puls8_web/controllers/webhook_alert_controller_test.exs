defmodule Puls8Web.WebhookAlertControllerTest do
  use Puls8Web.ConnCase, async: true

  describe "grafana" do
    import Puls8.AccountsFixtures

    test "POST /", %{conn: conn} do
      team = team_fixture()
      payload = File.read!("test/support/json/incoming-grafana-firing-input.json")
      conn = post(conn, ~p"/api/webhooks/#{team.id}/alerts/grafana", Jason.decode!(payload))
      assert %{"id" => alert_id} = json_response(conn, 200)
      assert alert = Puls8.Incidents.get_alert!(alert_id)
      assert alert.status == :firing
      assert alert.type == :grafana
      assert alert.started_at == ~U[2023-07-10 20:48:00.000000Z]
      assert alert.summary == "Surge in process count"
    end
  end
end
