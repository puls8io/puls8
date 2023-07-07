defmodule Puls8.Monitoring.ServiceIntegration do
  use Ecto.Migration

  def change do
    create table(:monitoring_integrations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :type, :integer, null: false

      add :service_id, references(:monitoring_services, on_delete: :delete_all, type: :binary_id),
        null: false

      timestamps()
    end

    create index(:monitoring_integrations, [:service_id])
  end
end
