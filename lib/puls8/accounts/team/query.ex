defmodule Puls8.Accounts.Team.Query do
  import Ecto.Query, warn: false
  alias Puls8.Accounts.Team

  def base, do: Team

  def for_user(query \\ base(), user) do
    team_ids = Enum.map(user.memberships, & &1.team_id)
    where(query, [t], t.id in ^team_ids)
  end
end
