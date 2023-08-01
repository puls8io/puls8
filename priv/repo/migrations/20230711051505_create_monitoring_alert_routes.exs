defmodule Puls8.Repo.Migrations.CreateMonitoringAlertRoutes do
  use Ecto.Migration

  def change do
    create table(:monitoring_alert_routes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :integer, null: false
      add :labels, {:array, :map}, null: false, default: []

      add :service_id,
          references(:monitoring_services, on_delete: :delete_all, type: :binary_id),
          null: false

      timestamps()
    end

    create index(:monitoring_alert_routes, [:service_id])
  end
end
