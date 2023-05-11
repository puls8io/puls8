defmodule Puls8.Accounts.Membership do
  use Ecto.Schema
  import Ecto.Changeset
  # This approach has concurrent issue. If one user gets added/granted to two
  # teams at the same time, one of the team settings will overwrite the other one!

  @primary_key {:team_id, :string, autogenerate: false}
  embedded_schema do
    field :roles, {:array, Ecto.Enum}, values: [:owner, :member]
  end

  def changeset(memberships, attrs) do
    memberships
    |> cast(attrs, [:roles, :team_id])
    |> validate_required([:team_id, :roles])
  end
end
