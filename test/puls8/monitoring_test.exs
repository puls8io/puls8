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

  describe "Integration" do
    import Puls8.MonitoringFixtures

    test "create_integration/2" do
      attrs = %{name: "Hello World", type: :grafana}
      team = team_fixture()
      assert {:ok, integration} = Monitoring.create_intergration(team, attrs)
      assert integration.name == "Hello World"
      assert integration.type == :grafana
      assert integration.team_id == team.id
    end
  end

  describe "IntegrationRule" do
    import Puls8.MonitoringFixtures

    test "create_intergration_rule/2" do
      integration = integration_fixture()
      service = service_fixture()

      attrs = %{"labels" => %{"job" => "myapp", "alertname" => "www status"}}
      assert {:ok, rule} = Monitoring.create_intergration_rule(integration, service, attrs)
      assert rule.integration_id == integration.id
      assert rule.service_id == service.id
    end
  end
end
