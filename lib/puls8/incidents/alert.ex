defmodule Puls8.Incidents.Alert do
  use Ecto.Schema
  import Ecto.Changeset

  alias Puls8.Accounts

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "incident_alerts" do
    field :ended_at, :utc_datetime_usec
    field :fingerprint, :string
    field :payload, :map
    field :started_at, :utc_datetime_usec
    field :status, Ecto.Enum, values: [firing: 0]
    field :summary, :string
    field :type, Ecto.Enum, values: [grafana: 0, prometheus: 1]
    belongs_to :team, Accounts.Team

    timestamps()
  end

  @doc false
  def changeset(alert, attrs) do
    alert
    |> cast(attrs, [:summary, :status, :started_at, :ended_at, :fingerprint, :type, :payload])
    |> validate_required([
      :summary,
      :status,
      :started_at,
      :fingerprint,
      :type,
      :payload
    ])
  end

  def put_team(%Ecto.Changeset{} = ch, %Accounts.Team{} = team) do
    put_assoc(ch, :team, team)
  end
end
