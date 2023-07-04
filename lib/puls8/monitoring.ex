defmodule Puls8.Monitoring do
  @moduledoc """
  The Monitoring context.
  """

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
end
