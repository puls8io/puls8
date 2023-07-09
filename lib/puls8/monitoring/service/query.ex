defmodule Puls8.Monitoring.Service.Query do
  import Ecto.Query
  alias Puls8.Monitoring.Service

  def base, do: Service

  def for_team(query \\ base(), team) do
    where(query, [s], s.team_id == ^team.id)
  end

  def by_scoped_id(query \\ base(), scoped_id) do
    where(query, [s], s.scoped_id == ^scoped_id)
  end
end
