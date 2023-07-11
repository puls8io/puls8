defmodule Puls8.Monitoring.IntegrationRule do
  use Ecto.Schema
  import Ecto.Changeset
  alias Puls8.Monitoring

  @primary_key {:id, Uniq.UUID, version: 7, autogenerate: true}
  @foreign_key_type :binary_id
  schema "monitoring_integration_rules" do
    field(:labels, :map)
    belongs_to(:integration, Monitoring.Integration)
    belongs_to(:service, Monitoring.Service)

    timestamps()
  end

  def changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:labels])
    |> validate_required([:labels])
  end

  def put_integreation(%Ecto.Changeset{} = ch, %Monitoring.Integration{} = integration) do
    put_assoc(ch, :integration, integration)
  end

  def put_service(%Ecto.Changeset{} = ch, %Monitoring.Service{} = service) do
    put_assoc(ch, :service, service)
  end
end
