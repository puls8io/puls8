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


    |> Repo.insert()
  end

  end
end
