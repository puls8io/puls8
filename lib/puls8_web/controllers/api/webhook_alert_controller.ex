defmodule Puls8Web.Api.WebhookAlertController do
  use Puls8Web, :controller

  def grafana(conn, webhook_params) do
    team = Puls8.Accounts.get_team!(webhook_params["team_id"])

    with {:ok, alert} <- create_alert(team, webhook_params) do
      json(conn, %{id: alert.id})
    end
  end

  defp create_alert(team, webhook_params) do
    Puls8.Incidents.create_alert(team, from_grafana_webhook(webhook_params))
  end

  defp from_grafana_webhook(webhook_params) do
    # TODO: are there more?
    alert = List.first(webhook_params["alerts"])
    {:ok, started_at, _offset} = DateTime.from_iso8601(alert["startsAt"])

    %{
      type: :grafana,
      fingerprint: alert["fingerprint"],
      started_at: started_at,
      status: alert["status"],
      summary: alert["annotations"]["summary"],
      payload: webhook_params
    }
  end
end
