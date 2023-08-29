defmodule Puls8.MonitoringTest do
  use Puls8.DataCase, async: false

  alias Puls8.Monitoring

  import Puls8.AccountsFixtures
  import Puls8.MonitoringFixtures

  describe "Service" do
    import Puls8.AccountsFixtures

    test "Phoenix.Param.to_param/1" do
      service = %Monitoring.Service{scoped_id: 100_393}
      assert Phoenix.Param.to_param(service) == "100393"
    end

    test "create_service/2" do
      team = team_fixture()
      valid_attrs = %{name: "My Website"}
      assert {:ok, service} = Monitoring.create_service(team, valid_attrs)
      assert service.name == "My Website"
      assert service.team_id == team.id
      assert service.scoped_id == 1
    end

    test "create_service/2 each team has its own scoped_id" do
      team1 = team_fixture(slug: "team-1")
      valid_attrs = %{name: "My Website"}
      {:ok, service} = Monitoring.create_service(team1, valid_attrs)
      assert service.scoped_id == 1
      {:ok, service} = Monitoring.create_service(team1, valid_attrs)
      assert service.scoped_id == 2

      team2 = team_fixture(slug: "team-2")

      {:ok, service} = Monitoring.create_service(team2, valid_attrs)
      assert service.scoped_id == 1
      {:ok, service} = Monitoring.create_service(team2, valid_attrs)
      assert service.scoped_id == 2
    end

    test "get_service_by_team! only works with scope of team" do
      service1 = service_fixture()
      service1_id = service1.id

      service2 = service_fixture()
      service2_id = service2.id

      assert %Monitoring.Service{id: ^service1_id} =
               Monitoring.get_service_by_team!(service1.scoped_id, service1.team)

      assert %Monitoring.Service{id: ^service2_id} =
               Monitoring.get_service_by_team!(service2.scoped_id, service2.team)
    end
  end

  describe "AlertRoute" do
    import Puls8.MonitoringFixtures
    alias Puls8.Monitoring.AlertRoute

    test "change_alert_route/2 with invalid attrs" do
      alert_route = %AlertRoute{}
      invalid_attr = %{}

      changeset = Monitoring.change_alert_route(alert_route, invalid_attr)
      refute changeset.valid?
      assert errors_on(changeset) == %{labels: ["can't be blank"], type: ["can't be blank"]}
    end

    test "change_alert_route/2 with valid attrs" do
      alert_route = %AlertRoute{}
      valid_attr = %{type: :grafana, labels: %{1 => %{key: "mykey", value: "myvalue"}}}

      changeset = Monitoring.change_alert_route(alert_route, valid_attr)
      assert changeset.valid?
    end

    test "create_alert_route/2" do
      service = service_fixture()

      attrs = %{
        labels: [
          %{"key" => "job", "value" => "myapp"},
          %{"key" => "alertname", "value" => "www status"}
        ],
        type: :grafana
      }

      assert {:ok, rule} = Monitoring.create_alert_route(service, attrs)
      assert rule.service_id == service.id
    end

    test "list_alert_route_by_labels/2 when the labels match" do
      labels = [
        %{"key" => "job", "value" => "myapp"},
        %{"key" => "alertname", "value" => "www status"}
      ]

      expected_alert_rule = alert_rule_fixture(labels: labels)

      assert [alert_rule] = Monitoring.list_alert_route_by_labels(labels)

      assert alert_rule.id == expected_alert_rule.id
    end

    test "list_alert_route_by_labels/2 when the labels doesn't match" do
      labels = [
        %{"key" => "job", "value" => "myapp"}
      ]

      _fixture = alert_rule_fixture(labels: labels)

      assert Monitoring.list_alert_route_by_labels([
               %{"key" => "alertname", "value" => "www status"}
             ]) == []
    end
  end
end
