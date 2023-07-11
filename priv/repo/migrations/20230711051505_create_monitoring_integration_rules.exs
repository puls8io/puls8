defmodule Puls8.Repo.Migrations.CreateMonitoringIntegrationRules do
  use Ecto.Migration

  def change do
    create table(:monitoring_integration_rules, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :labels, :map

      add :service_id,
          references(:monitoring_services, on_delete: :delete_all, type: :binary_id),
          null: false

      add :integration_id,
          references(:monitoring_integrations, on_delete: :delete_all, type: :binary_id),
          null: false

      timestamps()
    end

    create index(:monitoring_integration_rules, [:integration_id])
  end
end
