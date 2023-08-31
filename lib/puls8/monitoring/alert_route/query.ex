defmodule Puls8.Monitoring.AlertRoute.Query do
  import Ecto.Query, warn: false
  alias Puls8.Monitoring.AlertRoute

  def base, do: AlertRoute

  def for_team(query \\ base(), team) do
    from ar in query,
      join: s in assoc(ar, :service),
      where: s.team_id == ^team.id
  end

  def by_type(query \\ base(), type) do
    from ar in query, where: ar.type == ^type
  end
end
