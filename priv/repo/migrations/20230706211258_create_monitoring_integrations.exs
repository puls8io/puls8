defmodule Puls8.Monitoring.ServiceIntegration do
  use Ecto.Migration

  def change do
    create table(:monitoring_integrations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :type, :integer, null: false

      add :team_id, references(:teams, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:monitoring_integrations, [:team_id])
  end
end
