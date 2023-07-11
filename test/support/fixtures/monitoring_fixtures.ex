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

  def integration_fixture(attrs \\ %{}) do
    team = attrs[:team] || Puls8.AccountsFixtures.team_fixture()

    attrs =
      attrs
      |> Enum.into(%{
        name: "Grafana",
        type: :grafana
      })

    {:ok, integration} = Puls8.Monitoring.create_intergration(team, attrs)
    integration
  end
end
