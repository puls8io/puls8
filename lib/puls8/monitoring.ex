defmodule Puls8.Monitoring do
  @moduledoc """
  The Monitoring context.
  """

  alias Puls8.Repo
  alias Puls8.Accounts
  alias Puls8.Monitoring.Service

  @doc """
  Create a new service.
  """
  def create_service(%Accounts.Team{} = team, attrs \\ %{}) do
    %Service{}
    |> Service.changeset(attrs)
    |> Service.put_team(team)
    |> Repo.insert()
  end

  @doc false
  def change_service(%Service{} = service \\ %Service{}, attrs \\ %{}) do
    Service.changeset(service, attrs)
  end

  @doc """
  Find a service by scoped_id and team
  """
  def get_service_by_team!(scoped_id, %Accounts.Team{} = team) do
    scoped_id
    |> Service.Query.by_scoped_id()
    |> Service.Query.for_team(team)
    |> Repo.one!()
  end

  alias Puls8.Monitoring.AlertRoute

  def create_alert_route(%Service{} = service, attrs) do
    %AlertRoute{}
    |> AlertRoute.changeset(attrs)
    |> AlertRoute.put_service(service)
    |> Repo.insert()
  end

  def list_alert_routes do
    Repo.all(AlertRoute)
  end

  def change_alert_route(
        %AlertRoute{} = alert_route \\ %AlertRoute{},
        attrs \\ %{}
      ) do
    AlertRoute.changeset(alert_route, attrs)
  end

  def list_alert_route_by_labels(team, type, labels) do
    team
    |> AlertRoute.Query.for_team()
    |> AlertRoute.Query.by_type(type)
    |> Repo.all()
    |> Enum.filter(fn ar ->
      expected_labels =
        Enum.map(ar.labels, fn label -> %{"key" => label.key, "value" => label.value} end)

      expected_set = MapSet.new(expected_labels)
      lookup_set = MapSet.new(labels)
      MapSet.intersection(expected_set, lookup_set) == expected_set
    end)
  end
end
