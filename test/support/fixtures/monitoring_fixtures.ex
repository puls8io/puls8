defmodule Puls8.MonitoringFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Foo.Monitoring` context.
  """

  @doc """
  Generate a service.
  """
  def service_fixture(attrs \\ %{}) do
    team = attrs[:team] || Puls8.AccountsFixtures.team_fixture()

    attrs =
      attrs
      |> Enum.into(%{
        name: "some name"
      })

    {:ok, services} =
      team
      |> Puls8.Monitoring.create_service(attrs)

    services
  end

  def alert_rule_fixture(attrs \\ %{}) do
    service = attrs[:service] || service_fixture()

    attrs =
      attrs
      |> Enum.into(%{type: :grafana, labels: [%{"key" => "host", "value" => "localhost"}]})

    {:ok, alert_rule} = Puls8.Monitoring.create_alert_route(service, attrs)
    alert_rule
  end
end
