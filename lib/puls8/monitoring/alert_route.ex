defmodule Puls8.Monitoring.AlertRoute do
  use Ecto.Schema
  import Ecto.Changeset
  alias Puls8.Monitoring

  @primary_key {:id, Uniq.UUID, version: 7, autogenerate: true}
  @foreign_key_type :binary_id
  schema "monitoring_alert_routes" do
    field :type, Ecto.Enum, values: [grafana: 0, prometheus: 1]

    embeds_many :labels, Label, on_replace: :delete do
      field :key, :string
      field :value, :string
    end

    belongs_to(:service, Monitoring.Service)

    timestamps()
  end

  def changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:type])
    |> cast_embed(:labels,
      with: &label_changeset/2,
      sort_param: :labels_sort,
      drop_param: :labels_drop,
      required: true
    )
    |> validate_required([:type])
  end

  def put_service(%Ecto.Changeset{} = ch, %Monitoring.Service{} = service) do
    put_assoc(ch, :service, service)
  end

  defp label_changeset(label, attrs) do
    label
    |> cast(attrs, [:key, :value])
    |> validate_required([:key, :value])
  end
end
