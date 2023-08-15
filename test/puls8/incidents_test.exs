defmodule Puls8.IncidentsTest do
  use Puls8.DataCase, async: true

  alias Puls8.Incidents

  describe "alerts" do
    alias Puls8.Incidents.Alert

    import Puls8.IncidentsFixtures
    import Puls8.AccountsFixtures

    @invalid_attrs %{
      ended_at: nil,
      fingerprint: nil,
      payload: nil,
      started_at: nil,
      status: nil,
      summary: nil,
      type: nil
    }

    test "create_alert/1 with valid data creates a alert" do
      team = team_fixture()

      valid_attrs = %{
        fingerprint: "some fingerprint",
        payload: %{},
        started_at: ~U[2023-08-14 21:16:00.000000Z],
        status: 42,
        summary: "some summary",
        type: :grafana
      }

      assert {:ok, %Alert{} = alert} = Incidents.create_alert(team, valid_attrs)
      assert alert.ended_at == nil
      assert alert.fingerprint == "some fingerprint"
      assert alert.payload == %{}
      assert alert.started_at == ~U[2023-08-14 21:16:00.000000Z]
      assert alert.status == 42
      assert alert.summary == "some summary"
      assert alert.type == :grafana
    end

    test "create_alert/1 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Incidents.create_alert(team, @invalid_attrs)
    end

    test "update_alert/2 with valid data updates the alert" do
      alert = alert_fixture()

      update_attrs = %{
        ended_at: ~U[2023-08-15 21:16:00.000000Z],
        fingerprint: "some updated fingerprint",
        payload: %{},
        status: 43,
        summary: "some updated summary",
        type: :prometheus
      }

      assert {:ok, %Alert{} = alert} = Incidents.update_alert(alert, update_attrs)
      assert alert.ended_at == ~U[2023-08-15 21:16:00.000000Z]
      assert alert.fingerprint == "some updated fingerprint"
      assert alert.payload == %{}
      assert alert.started_at == alert.started_at
      assert alert.status == 43
      assert alert.summary == "some updated summary"
      assert alert.type == :prometheus
    end
  end
end
