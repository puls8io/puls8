defmodule Puls8.Monitoring.Integration do
  use Ecto.Schema
  import Ecto.Changeset
  alias Puls8.Monitoring

  @primary_key {:id, Uniq.UUID, version: 7, autogenerate: true}
  @foreign_key_type :binary_id
  schema "monitoring_integrations" do
    field :name, :string
    field :type, Ecto.Enum, values: [grafana: 0, prometheus: 1]
    belongs_to :service, Monitoring.Service

    timestamps()
  end

  def changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:name, :type])
    |> validate_required([:name, :type])
  end

  def put_service(%Ecto.Changeset{} = ch, %Monitoring.Service{} = service) do
    put_assoc(ch, :service, service)
  end
end
