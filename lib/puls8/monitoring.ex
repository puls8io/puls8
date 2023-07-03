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
end
