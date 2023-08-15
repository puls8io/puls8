defmodule Puls8.Repo.Migrations.CreateAlerts do
  use Ecto.Migration

  def change do
    create table(:incident_alerts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :summary, :string, null: false
      add :status, :integer, null: false
      add :started_at, :utc_datetime_usec, null: false
      add :ended_at, :utc_datetime_usec
      add :fingerprint, :string, null: false
      add :type, :integer, null: false
      add :payload, :map, null: false
      add :team_id, references(:teams, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:incident_alerts, [:team_id])
    create unique_index(:incident_alerts, [:team_id, :type, :fingerprint])
  end
end
