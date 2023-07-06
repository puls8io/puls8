defmodule Puls8.Monitoring do
  @moduledoc """
  The Monitoring context.
  """

  import Ecto.Query

  alias Puls8.Repo
  alias Puls8.Monitoring.Service

  @doc """
  Create a new service.
  """
  def create_service(team, attrs \\ %{}) do
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
  def get_service_by_team!(scoped_id, team) do
    team_id = team.id
    query = from q in Service, where: q.scoped_id == ^scoped_id, where: q.team_id == ^team_id
    Repo.one!(query)
  end
end
