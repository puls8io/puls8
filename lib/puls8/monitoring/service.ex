defmodule Puls8.Monitoring.Service do
  use Ecto.Schema
  import Ecto.Changeset
  alias Puls8.Accounts

  @primary_key {:id, Uniq.UUID, version: 7, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :scoped_id}
  schema "monitoring_services" do
    field :scoped_id, :integer, read_after_writes: true
    field :name, :string
    belongs_to :team, Accounts.Team

    timestamps()
  end

  @doc false
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def put_team(%Ecto.Changeset{} = ch, %Accounts.Team{} = team) do
    put_assoc(ch, :team, team)
  end
end
