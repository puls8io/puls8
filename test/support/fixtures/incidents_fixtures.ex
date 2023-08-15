defmodule Puls8.IncidentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Puls8.Incident` context.
  """

  @doc """
  Generate a alert.
  """
  def alert_fixture(attrs \\ %{}) do
    team = attrs[:team] || Puls8.AccountsFixtures.team_fixture()

    attrs =
      Enum.into(attrs, %{
        fingerprint: "some fingerprint",
        payload: %{},
        started_at: ~U[2023-08-14 21:16:00.000000Z],
        status: 42,
        summary: "some summary",
        type: :grafana
      })

    {:ok, alert} = Puls8.Incidents.create_alert(team, attrs)

    alert
  end
end
