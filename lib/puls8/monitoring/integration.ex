defmodule Puls8.Monitoring.Integration do
  use Ecto.Schema
  import Ecto.Changeset
  alias Puls8.Accounts

  @primary_key {:id, Uniq.UUID, version: 7, autogenerate: true}
  @foreign_key_type :binary_id
  schema "monitoring_integrations" do
    field :name, :string
    field :type, Ecto.Enum, values: [grafana: 0, prometheus: 1]
    belongs_to :team, Accounts.Team

    timestamps()
  end

  def changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:name, :type])
    |> validate_required([:name, :type])
  end

  def put_team(%Ecto.Changeset{} = ch, %Accounts.Team{} = team) do
    put_assoc(ch, :team, team)
  end
end
