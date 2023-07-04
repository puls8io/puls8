defmodule Puls8.MonitoringTest do
  use Puls8.DataCase, async: false

  alias Puls8.Monitoring

  import Puls8.AccountsFixtures

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
  end
end
