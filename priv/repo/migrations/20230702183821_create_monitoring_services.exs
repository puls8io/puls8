defmodule Puls8.Repo.Migrations.CreateMonitoringServices do
  use Ecto.Migration

  def up do
    create table(:monitoring_services, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :scoped_id, :integer, null: false
      add :name, :string, null: false
      add :team_id, references(:teams, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:monitoring_services, [:team_id])
    create unique_index(:monitoring_services, [:team_id, :scoped_id])

    execute """
    CREATE TRIGGER fill_scoped_id
    BEFORE INSERT ON monitoring_services
    FOR EACH ROW
    EXECUTE FUNCTION fill_scoped_id('monitoring_services');
    """
  end

  def down do
    execute "DROP TRIGGER fill_scoped_id on monitoring_services"
    drop table(:monitoring_services)
  end
end
